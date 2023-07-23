import           Data.List                      ( isInfixOf )
import           Graphics.X11.Xlib
import           System.IO
import           System.Process                 ( readProcess
                                                , runCommand
                                                )
import           Text.Regex.Posix               ( (=~) )

-- Check if a monitor is connected from xrandr output
isConnectedMonitor :: String -> Bool
isConnectedMonitor = isInfixOf " connected "

-- Parse monitor information from a line
parseMonitor :: String -> [String]
parseMonitor line = do
  let match = line =~ pattern :: [[String]]
  case match of
    -- Extract monitor details from the regex match
    [[_, name, width, height, offsetX, offsetY]] ->
      [name, width, height, offsetX, offsetY]
    _ -> []
  where pattern = "^([^ ]*).*\\b([-0-9]+)x([-0-9]+)\\+([-0-9]+)\\+([-0-9]+).*$"

-- Get the current mouse coordinates
getMouseCoordinates :: IO (Int, Int)
getMouseCoordinates = openDisplay "" >>= \display ->
  rootWindow display (defaultScreen display) >>= \root ->
    queryPointer display root >>= \(_, _, _, x, y, _, _, _) ->
      closeDisplay display >> return (fromIntegral x, fromIntegral y)

-- Get the active monitor based on mouse coordinates
getActiveMonitor :: (Int, Int) -> [[String]] -> Maybe [String]
getActiveMonitor (x, y) monitors = go monitors
 where
  go [] = Nothing
  go (monitor : rest) =
    let [_, width, height, offsetXStr, offsetYStr] = monitor
        offsetX = read offsetXStr :: Int
        offsetY = read offsetYStr :: Int
        width'  = read width :: Int
        height' = read height :: Int
        maxX    = offsetX + width'
        maxY    = offsetY + height'
    in  if x >= offsetX && x <= maxX && y >= offsetY && y <= maxY
          then Just monitor
          else go rest


-- Run FFmpeg on the active monitor
runFFmpegOnActiveMonitor :: [String] -> IO ()
runFFmpegOnActiveMonitor monitor =
  let [_, widthStr, heightStr, offsetXStr, offsetYStr] = monitor
      protocol       = "-f x11grab" -- Use x11grab to record the screen
      time           = "300"
      fps            = "30"
      scale          = "1920:-1:flags=lanczos"
      custom         = ""
      outputFilePath = "/home/n/Pictures/gifs/1output.mp4"
      ffmpegCommand =
        "ffmpeg "
          ++ protocol
          ++ " -video_size "
          ++ widthStr
          ++ "x"
          ++ heightStr
          ++ " -t "
          ++ time
          ++ " -i :0.0+"
          ++ offsetXStr
          ++ ","
          ++ offsetYStr
          ++ " -vf fps="
          ++ fps
          ++ ",scale="
          ++ scale
          ++ " "
          ++ custom
          ++ " -y "
          ++ outputFilePath
  in  runCommand ffmpegCommand >> return ()


main :: IO ()
main = do
  output <- readProcess "xrandr" [] ""
  let connectedMonitors = filter isConnectedMonitor (lines output)
      monitors          = map parseMonitor connectedMonitors
  mouseCoordinates <- getMouseCoordinates
  let activeMonitor = getActiveMonitor mouseCoordinates monitors
  case activeMonitor of
    Just monitor -> runFFmpegOnActiveMonitor monitor
    Nothing      -> putStrLn "No active monitor found."
