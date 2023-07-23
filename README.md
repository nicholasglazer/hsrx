# hsrx

**Haskell Screen Recorder X11 (hsrx)** is a screen recording tool designed to work on X11 systems and written in Haskell. 
The software identifies the active monitor based on the position of the mouse pointer and initiates screen recording for that particular monitor.

## Features

- Detection of the active monitor based on the mouse's position.
- Initiation of screen recording on the detected active monitor using FFmpeg.
- Ability to set the duration of recording and output path.

## Prerequisites

The following software need to be installed on your system:

- Haskell
- X11
- FFmpeg

## Installation

To install **hsrx**, you need to clone this repository first:

```bash
git clone https://github.com/nicholasglazer/hsrx.git
```

After cloning the repository, navigate into the directory and compile the Haskell code:

```bash
cd hsrx
ghc -o hsrx Main.hs
```
You might need to use `-dynamic` flag to compile.

## Usage

To run **hsrx** after installation, execute the following command:

```bash
./hsrx
```

This will initiate the screen recording of the active monitor where the mouse pointer is located. The recording continues for the pre-specified duration and the output is saved to the designated path.

## TODO

This project is still under development. Here are some of the enhancements planned for future versions:

1. **Accept arguments**: To enable video recording, the application needs to accept arguments for different recording modes. This will provide more flexibility in recording options.
   
2. **Implement screenshot functionality**: In addition to recording videos, the application should also be able to take screenshots of the active monitor.
   
3. **Record selected area**: Enhance the application to allow users to select a specific area of the screen for recording or taking a screenshot, instead of capturing the entire screen.
   
4. **Save to buffer**: To improve usability, the recorded gif or screenshot should be saved directly to the clipboard. This would allow users to easily paste the media into other applications that support this feature.
   
5. **Additional features**: We are always looking for ways to improve and add new features. Please feel free to suggest enhancements or contribute to the project.

## Contributing

We welcome contributions from everyone. If you're interested in contributing, feel free to submit a Pull Request.

## License

This project is licensed under the MIT license. For more details, please see the [LICENSE](LICENSE) file.

## Acknowledgements

We would like to express our gratitude to:

- The FFmpeg project, for the screen recording capabilities.
- The Haskell and X11 communities for their continuous support and valuable resources.

