module Main where

import UI.NCurses


main :: IO ()
main = runCurses $ do
    setEcho False
    w <- newWindow 23 23 1 1
    updateWindow w $ do
        drawBoard (0, 0) 7
        drawBoard (1, 1) 1
    render
    moveAround w

drawBoard :: (Integer, Integer) -> Integer -> Update ()
drawBoard (y, x) cellsize = do
    moveCursor (cellsize + y) x
    drawLineH (Just glyphLineH) (cellsize * 3 + 2)
    moveCursor (cellsize + y + cellsize + 1) x
    drawLineH (Just glyphLineH) (cellsize * 3 + 2)

    moveCursor y (cellsize + x)
    drawLineV (Just glyphLineV) (cellsize * 3 + 2)
    moveCursor y (cellsize + x + cellsize + 1)
    drawLineV (Just glyphLineV) (cellsize * 3 + 2)

moveAround :: Window -> Curses ()
moveAround w = loop
  where
    loop = do
        ev <- getEvent w Nothing
        case ev of
            Nothing -> loop
            Just (EventCharacter 'q') -> return ()
            Just (EventSpecialKey k) -> do
                (y, x) <- getCursor w
                updateWindow w $ case k of
                    KeyUpArrow -> moveCursor (y - 1) x
                    KeyDownArrow -> moveCursor (y + 1) x
                    KeyLeftArrow -> moveCursor y (x - 1)
                    KeyRightArrow -> moveCursor y (x + 1)
                    _ -> return ()
                render
                loop
