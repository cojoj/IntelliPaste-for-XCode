IntelliPaste-for-XCode
======================

## Overview

IntelliPaste is an Xcode plugin that makes copy-pasting between header and method files easier. 

## Usage

Copy one or more methods from the method file. Then use `Shift+Cmd+V` or `Edit` > `Paste Methods` to copy paste them with the correct format to the header file. Alternatively, the starting point can be the header file, which is then copy-pasted to the method file.

![IntelliPaste-Demo.gif](https://raw.githubusercontent.com/RobertGummesson/IntelliPaste-for-XCode/master/Screenshots/IntelliPaste-Demo.gif)

## Installation

IntelliPaste is available through [Alcatraz - The package manager for Xcode](http://alcatraz.io/)

If you rather compile it yourself, simply build the Xcode project and restart Xcode. The plugin will automatically be installed in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`. To uninstall, just remove the plugin from there (and restart Xcode).

The plug-in is developed and tested using Xcode 5.1.1. 

## Known issues

* Methods with comments containing curly brackets could under some circumstances fail to paste. A fix for this is on my TODO-list. 

## License

    Copyright (c) 2014, Robert Gummesson
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
