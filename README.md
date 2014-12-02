CodeCoverage4iOS
================

iOS code coverage test tool. 

基于lcov-1.11的iOS代码覆盖率测试工具，适用与iOS真机与模拟器。

### 环境准备

***Mac OS X*** :10.8.5+ 建议10.9

***Xcode*** :5.0+ 建议6.1



###Xcode工程配置
1. 拷贝**CodeCoverage4iOS**项目到主工程根目录，即${your_proj.xcworkspace}所在目录

2. 在Xcode中设置全局变量 **NT_COVERAGE=1**，用于代码覆盖率开关控制，如配置路径 `iOSProj —> TARGTS -> MyApp -> Build Settings -> Preprocessor Macros -> Debug`中添加**NT_COVERAGE=1**

3. 对主工程及依赖工程在**Build Settings**做如下配置:
  * Generate Debug Symbols 配置成YES
  * Generate Test Coverage Files 配置成YES
  * Instrument Program Flow 配置成YES
  
  例如:`iOSProj —> TARGTS -> MyApp -> Build Settings -> Generate Debug Symbols` 
  
  **以上配置建议仅在Debug下配置为YES，避免影响Release打包**

4. 在AppDelegate.m中添加如下代码:
  ```Objective-C
  - (void)applicationDidEnterBackground:(UIApplication *)application
  {
      ...
      #if NT_COVERAGE
          #if !TARGET_IPHONE_SIMULATOR
              NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
              NSString *documentsDirectory = [paths objectAtIndex:0];
              setenv("GCOV_PREFIX", [documentsDirectory cStringUsingEncoding:NSUTF8StringEncoding], 1);
              setenv("GCOV_PREFIX_STRIP", "13", 1);
          #endif
          
          extern void __gcov_flush(void);
          __gcov_flush();
      #endif
      ...
  }
  ```
  
  当程序被拉到后台时调用`__gcov_flush()`生成**.gcda**文件，此文件中记录了代码覆盖率，注意`__gcov_flush()`可重复调用，记录为追加写。
  * iOS Simulator : **.gcda**文件会生成到默认路径`~/Library/Developer/Xcode/DerivedData/iOSProj-cndbgdtazzzhaebuyvgjsqmkvwdr/Build/Intermediates/MyApp.build/Debug-iphonesimulator/MyApp.build/Objects-normal/i386`·下
  * iPhone :  **.gcda**文件会生成到对应App沙盒`Document/${CURRENT_ARCH}/`下

5. 在**Build Phases**中添加执行脚本:

  在`TARGTS -> MyApp -> Build Phases -> New Run Script Phase`中编辑**Run Script** 添加 `CodeCoverage4iOS/exportenv.sh`
  
  **注意** : 要求对主工程及依赖工程都需要做此配置，主要脚本执行路径为相对路径，比如依赖工程与主工程同级目录，那么需要将脚本路径修改为相对路径`../CodeCoverage4iOS/exportenv.sh`
  
###构建并安装程序

完成以上配置可以对Xcode工程进行构建,在使用Xcode安装app前确保CodeCoverage4iOS目录下**envs.sh**文件已删除

**注意** : 如果只执⾏Build`Command+B`也会产⽣envs.sh文件,建议Build成功后检查删除envs.sh⽂件,再执⾏`Command+R`,确保envs.sh没有上次build产生的残余内容。

###收集代码覆盖率

1. APP安装成功后可以对进行相应的测试操作，完成操作后点击**Home键**，此时程序会生成.gcda文件到对应目录。
2. 生成覆盖率报告:
  * iOS Simulator : 如果测试设备为iOS模拟机可直接双击执行`CodeCoverage4iOS/getcov`
  * iPhone : 如果测试设备为iPhone真机，首先需要从沙盒`Document/${CURRENT_ARCH}`下拷贝**.gcda**文件到`CodeCoverage4iOS/gcda`下，再执行`CodeCoverage4iOS/getcov`
  
  执行`CodeCoverage4iOS/getcov`过程中会在目录`CodeCoverage4iOS/coverage`下生成**coverage.info**文件，根据coverage.info文件生成最终报告。**PS:如果需要合并测试结果，需要保留此文件**
  
  **测试报告生成路径:`CodeCoverage4iOS/report/index.html`**
  
###过滤结果

  如果需要对收集的覆盖率结果进行过滤，可以编辑`CodeCoverage4iOS/getcov`中的函数`exclude_data()`
  ```shell
  exclude_data()
  {
      LCOV --remove $COVERAGE_INFO_DIR/${LCOV_INFO} "Developer/SDKs/*" -d "${OBJ_DIR}" -o $COVERAGE_INFO_DIR/${LCOV_INFO}
      LCOV --remove $COVERAGE_INFO_DIR/${LCOV_INFO} "main.m" -d "${OBJ_DIR}" -o $COVERAGE_INFO_DIR/${LCOV_INFO}
      # Remove other patterns here...
  }
  ```

###合并多个Coverage.info⽂件⽣成覆盖率报告:
1. 将Coverage.info文件全部放置到`CodeCoverage4iOS/coverage`下,如 `Coverage1.info、Coverage2.info、Coverage3.info`
2. 执行`CodeCoverage4iOS/mergecov` 生成合并后的报告
  
###参考文献

https://developer.apple.com/library/ios/qa/qa1514/_index.html

http://qualitycoding.org/xcode-code-coverage/
  


  
  


