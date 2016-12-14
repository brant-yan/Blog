{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Help where

import Foundation
import Yesod.Core
import Data.Text (Text)


getHelpR :: Int -> Handler Html
getHelpR  myp = defaultLayout $ do
                [whamlet|This is Help Page #{myp}|]
                myNewHelp 4444

myNewHelp :: Int -> Widget
myNewHelp n = [whamlet| You give me #{n}|]


getRedirectR :: Handler Html
getRedirectR = redirect $ HelpR  55555





getRenderObjectR :: Text -> Handler Html
getRenderObjectR t = defaultLayout $ [whamlet|This is RenderString Page #{t}|]