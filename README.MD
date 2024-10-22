## Avorion Audio Encoding Tools

 * Avorion Audio Encoding Tools is a bundle of Windows Batch Shell scripts to ease the audio production for Avorion modders, powered by ffmpeg.

 * [ Download](https://github.com/CansecoDev/AAET/releases/download/v1.0/AAET.ZIP)

-------------------------------------------------------------------------------
### Features

 * Encode any audio file to what it requires with ease.

 * Encode multiple audio files at once given a category.

 * Easy to use (drag and drop).

 * Accepts parameters for advanced users and automated use cases.

-------------------------------------------------------------------------------
### Usage

 * Drag and drop either a single audio file, or a directory containing multiple audio files to AAET, then it will ask for the encoding category, which can be either ui, 3d or mx. Finally it will produce files with this names at the same directory they were originally located:

   ``{original file/s}_CONVERTED.{EXT}``

 * You can also use the command line like this:

     ```bat
     AAET {input} {format} [output] [--no-suffix]
     ```

   - input determines the input path, it must be either an audio file or a directory containing audio files.

   - format determines the encoding category:
     - ui to encode the audio for SFX that plays at UI level.
     - 3d to encode the audio for SFX that plays on the 3D world.
     - mx to encode the audio for Music.

   - output determines the output path, defaulting to the same as the input, determining the output automatically disables the "Press any key to exit" message.

   - --no-suffix will make it not add the _CONVERTED suffix to the files, this is only functional if determining the output directory.

-------------------------------------------------------------------------------
### Requirements

 * This will virtually work on any system that runs an updated Windows 10.

 * For Linux users, you can apt/yum install ffmpeg, then take a look at the provided .BAT files and use the same parameters from there.

-------------------------------------------------------------------------------
### Legal

 * This file is licensed under the GNU Lesser General Public License, v2.1

   See LICENSE.TXT for details.
