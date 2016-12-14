{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Help where

import Handler.Import

getHelpR :: Handler Html
getHelpR = defaultLayout $ do
            $(widgetFile "widget/help")


