{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Foundation where

import Yesod.Core

import Text.Hamlet (HtmlUrl, hamlet,hamletFile)
import Text.Blaze.Renderer.String (renderHtml)
import Data.Text (Text)
import Yesod.Static
import Yesod.Form
import Yesod.Form.Jquery





import Database.Persist.Sqlite
import qualified Database.Persist
import Yesod.Core
import Data.Conduit
import Blaze.ByteString.Builder.Char.Utf8 (fromText)
import Yesod.Persist
import Data.Text (Text)
import Control.Monad.Trans.Resource (runResourceT)
import Control.Monad.Logger (runStderrLoggingT)
import Orm
import Settings



staticFiles "static"

data App = App{getStatic::Static
             , appPool   :: ConnectionPool}


mkYesodData "App" $(parseRoutesFile "config/routes")

instance Yesod App where
   defaultLayout = defaultDashboard

instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend
    runDB action = do
        App s pool <- getYesod
        runSqlPool action pool

toolbarWidget :: Widget
toolbarWidget = do
        maybeName <- lookupCookie "login-name"
        $(widgetFile "widget/toolbar_v")

defaultDashboard :: Widget -> Handler Html
defaultDashboard widget = do
    pc <- widgetToPageContent widget
    toolbar <- widgetToPageContent toolbarWidget
    giveUrlRenderer $( hamletFile "templates/dashboard/default.hamlet")


homepageDashboard :: Widget -> Handler Html
homepageDashboard widget = do
                    pc <- widgetToPageContent widget
                    mmsg <- getMessage
                    toolbar <- widgetToPageContent toolbarWidget
                    giveUrlRenderer $( hamletFile "templates/dashboard/homepage.hamlet")

leftFrame :: Widget ->  Handler Html
leftFrame widget = do
  pc <- widgetToPageContent widget
  giveUrlRenderer $( hamletFile "templates/frame/left.hamlet")

rightFrame :: Widget ->  Handler Html
rightFrame widget = do
  pc <- widgetToPageContent widget
  giveUrlRenderer $( hamletFile "templates/frame/right.hamlet")



instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

-- And tell us where to find the jQuery libraries. We'll just use the defaults,
-- which point to the Google CDN.
instance YesodJquery App where
    --urlJqueryJs :: App -> Either (Route App) Text
    urlJqueryJs _ = Right "/static/jquery.min.js"

    --urlJqueryUiJs :: App -> Either (Route App) Text
    urlJqueryUiJs _ = Right "/static/jquery-ui.min.js"

    --urlJqueryUiCss :: App -> Either (Route App) Text
    urlJqueryUiCss _ = Right "/static/jquery-ui.css"
