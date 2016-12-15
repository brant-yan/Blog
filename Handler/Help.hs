{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Help where

import Handler.Import

getHelpR :: Handler Html
getHelpR = homepageDashboard $ do
           let content=  $(widgetFile "widget/help_v")
           $(widgetFile "frame/center")


