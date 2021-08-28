@ECHO OFF
@TITLE Avorion Audio Encoding Tools
SETLOCAl enableDelayedExpansion
CLS

:DoStart
GOTO DoHeader

:DoHeader
PUSHD "%~dp0"
GOTO HeadInit

    :HeadInit
    SET ffmpegConfigUi=-hide_banner -loglevel error -y -c:a pcm_s16le -qscale:a 10 -ac 1 -ar 44100
    SET ffmpegConfig3D=-hide_banner -loglevel error -y -c:a pcm_s24le -qscale:a 10 -ac 1 -ar 96000
    SET ffmpegConfigMx=-hide_banner -loglevel error -y -c:a libvorbis -qscale:a 10 -ac 2 -ar 44100
    SET runDir="%~dp0"
    SET ffmpeg=%runDir:~0,-1%\ffmpeg\bin\ffmpeg.exe"
    SET inputItem="%~dpnx1"
    SET inputItemName="%~n1"
    SET encodeCatOverride=%2
    SET outputOverride=%3
    SET suffixOverride=%4
    GOTO HeadOverrides
    
    :HeadOverrides
    GOTO HeadOverrideEncodeCategory
    
        :HeadOverrideEncodeCategory
        IF "%encodeCatOverride%" == "ui" GOTO HeadOverrideEncodeCategoryUI
        IF "%encodeCatOverride%" == "3d" GOTO HeadOverrideEncodeCategory3D
        IF "%encodeCatOverride%" == "mx" GOTO HeadOverrideEncodeCategoryMX
        GOTO HeadOverrideOutput
        
            :HeadOverrideEncodeCategoryUI
            SET ffmpegConfig=%ffmpegConfigUi%
            SET extension=.wav
            GOTO HeadOverrideOutput
            
            :HeadOverrideEncodeCategory3D
            SET ffmpegConfig=%ffmpegConfig3D%
            SET extension=.wav
            GOTO HeadOverrideOutput
            
            :HeadOverrideEncodeCategoryMX
            SET ffmpegConfig=%ffmpegConfigMx%
            SET extension=.ogg
            GOTO HeadOverrideOutput
        
        :HeadOverrideOutput
        FOR %%i IN (%outputOverride%) DO IF EXIST %%~si\NUL GOTO HeadOverrideOutputDefined
        FOR %%i IN (%inputItem%) DO IF EXIST %%~si\NUL GOTO HeadOverrideOutputIsDirectory
        SET outputPath="%~dp1"
        GOTO HeadOverrideSuffix

            :HeadOverrideOutputDefined
            SET outputPath=%outputOverride%
            GOTO HeadOverrideSuffix
            
            :HeadOverrideOutputIsDirectory
            SET outputPath="%~dp1"\"%~n1"
            GOTO HeadOverrideSuffix
         
        :HeadOverrideSuffix
        IF "%suffixOverride%" == "--no-suffix" GOTO HeadOverrideSuffixSet
        SET suffix=_CONVERTED
        GOTO HeadEnd
            
            :HeadOverrideSuffixSet
            SET suffix=
            GOTO HeadEnd

    :HeadEnd
    GOTO DoInit

:DoInit
GOTO DoCheckDragDirectory

    :DoCheckDragDirectory
    IF %inputItem% == "" GOTO DoHelp
    FOR %%i IN (%inputItem%) DO IF EXIST %%~si\NUL GOTO DoProcDirectory
    GOTO DoCheckSingleFile

        :DoProcDirectory
        IF "%ffmpegConfig%" == "" GOTO LoopProcDirectorySelectEnc
        GOTO DoEncodeDirectory
        
            :LoopProcDirectorySelectEnc
            CLS
            ECHO.
            ECHO  Are the files in this directory UI, 3D or Music audio files?
            ECHO   - Type "ui" for user interface audio, like clicks and beeps.
            ECHO   - Type "3d" for 3D enviromental SFX, like shoots and explosions.
            ECHO   - Type "mx" for music.
            ECHO.
            SET /P ffmpegConfigSelect=Type one of the above (without quotations): 
            IF "%ffmpegConfigSelect%" == "ui" GOTO LoopProcDirectorySelectEncUI
            IF "%ffmpegConfigSelect%" == "3d" GOTO LoopProcDirectorySelectEnc3D
            IF "%ffmpegConfigSelect%" == "mx" GOTO LoopProcDirectorySelectEncMX
            GOTO LoopProcDirectorySelectEnc
            
                :LoopProcDirectorySelectEncUI
                SET ffmpegConfig=%ffmpegConfigUi%
                SET extension=.wav
                GOTO DoEncodeDirectory
                
                :LoopProcDirectorySelectEnc3D
                SET ffmpegConfig=%ffmpegConfig3D%
                SET extension=.wav
                GOTO DoEncodeDirectory
                
                :LoopProcDirectorySelectEncMX
                SET ffmpegConfig=%ffmpegConfigMx%
                SET extension=.ogg
                GOTO DoEncodeDirectory

        :DoEncodeDirectory
        ECHO Processing "%outputPath:"=%\" ...
        FOR %%f IN ("%inputItem:~1,-1%\*.*") DO %ffmpeg% -i "%%f" %ffmpegConfig% "%outputPath:"=%\%%~nf%suffix%%extension%"
        ECHO Finished!
        GOTO DoEnd

    :DoCheckSingleFile
    IF EXIST %inputItem% GOTO DoProcSingleFile
    GOTO DoHelp
    
        :DoProcSingleFile
        IF "%ffmpegConfig%" == "" GOTO LoopProcSingleFileSelectEnc
        GOTO DoEncodeSingleFile
    
            :LoopProcSingleFileSelectEnc
            CLS
            ECHO.
            ECHO  Is this an UI, 3D or Music audio file?
            ECHO   - Type "ui" for user interface audio, like clicks and beeps.
            ECHO   - Type "3d" for 3D enviromental SFX, like shoots and explosions.
            ECHO   - Type "mx" for music.
            ECHO.
            SET /P ffmpegConfigSelect=Type one of the above (without quotations): 
            IF "%ffmpegConfigSelect%" == "ui" GOTO LoopProcSingleFileSelectEncUI
            IF "%ffmpegConfigSelect%" == "3d" GOTO LoopProcSingleFileSelectEnc3D
            IF "%ffmpegConfigSelect%" == "mx" GOTO LoopProcSingleFileSelectEncMX
            GOTO LoopProcSingleFileSelectEnc
            
                :LoopProcSingleFileSelectEncUI
                SET ffmpegConfig=%ffmpegConfigUi%
                SET extension=.wav
                GOTO DoEncodeSingleFile
                
                :LoopProcSingleFileSelectEnc3D
                SET ffmpegConfig=%ffmpegConfig3D%
                SET extension=.wav
                GOTO DoEncodeSingleFile
                
                :LoopProcSingleFileSelectEncMX
                SET ffmpegConfig=%ffmpegConfigMx%
                SET extension=.ogg
                GOTO DoEncodeSingleFile

        :DoEncodeSingleFile
        ECHO Processing: "%outputPath:"=%\%inputItemName:"=%%suffix%%extension%" ...
        %ffmpeg% -i %inputItem% %ffmpegConfig% "%outputPath:"=%\%inputItemName:"=%%suffix%%extension%"
        ECHO Finished!
        GOTO DoEnd

    :DoHelp
    TYPE %runDir:~0,-1%\USAGE.TXT"
    GOTO DoEnd

:DoEnd
ECHO Press any key to exit.
PAUSE >>NUL
GOTO DoExit

:DoExit
EXIT