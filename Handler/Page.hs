{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Page where

import Handler.Import
import Data.Text as DT
import Orm
import Handler.Blog


{-
1.提供渲染逻辑
-}




{-
2.提供业务页面
-}

getPageR :: Int -> Handler Html
getPageR pageIndex = homepageDashboard $ do
          $(widgetFile "frame/center")
          where content = do
                    blogListWidget pageIndex
                    pageWidget (pageIndex+1)