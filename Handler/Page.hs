{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Page where
import Data.Text as DT

import Handler.Import
import Snippet.BlogS
import Snippet.PageS

getPageR :: Int -> Handler Html
getPageR pageIndex = homepageDashboard $ do
          $(widgetFile "frame/center")
          where content = do
                    blogListWidget pageIndex
                    pageWidget (pageIndex+1)