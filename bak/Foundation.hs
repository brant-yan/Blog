{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Foundation where

import Yesod.Core

import Text.Hamlet (HtmlUrl, hamlet)
import Text.Blaze.Renderer.String (renderHtml)
import Data.Text (Text)
import Yesod.Static
import Yesod.Form
import Yesod.Form.Jquery

staticFiles "static"

data App = App{getStatic::Static}

mkYesodData "App" $(parseRoutesFile "config/routes")

instance Yesod App



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

-- The datatype we wish to receive from the form
data PPerson = PPerson
    { personName          :: Text
    }
  deriving Show

-- Declare the form. The type signature is a bit intimidating, but here's the
-- overview:
--
-- * The Html parameter is used for encoding some extra information. See the
-- discussion regarding runFormGet and runFormPost below for further
-- explanation.
--
-- * We have our Handler as the inner monad, which indicates which site this is
-- running in.
--
-- * FormResult can be in three states: FormMissing (no data available),
-- FormFailure (invalid data) and FormSuccess
--
-- * The Widget is the viewable form to place into the web page.
--
-- Note that the scaffolded site provides a convenient Form type synonym,
-- so that our signature could be written as:
--
-- > personForm :: Form Person
--
-- For our purposes, it's good to see the long version.
personForm :: Html -> MForm Handler (FormResult PPerson, Widget)
personForm = renderDivs $ PPerson
    <$> areq textField "Name" Nothing

-- The GET handler displays the form
getPersonR :: Handler Html
getPersonR = do
    -- Generate the form to be displayed
    (widget, enctype) <- generateFormPost personForm
    defaultLayout $ do
        [whamlet|
            <p>
                The widget generated contains only the contents
                of the form, not the form tag itself. So...
            <form method=post action=@{PersonR} enctype=#{enctype}>
                ^{widget}
                <p>It also doesn't include the submit button.
                <button>Submit
        |]
        [whamlet|<p>
                    This is my page
        |]

-- The POST handler processes the form. If it is successful, it displays the
-- parsed person. Otherwise, it displays the form again with error messages.
postPersonR :: Handler Html
postPersonR = do
    ((result, widget), enctype) <- runFormPost personForm
    case result of
        FormSuccess person -> defaultLayout [whamlet|<p>#{show person}|]
        _ -> defaultLayout
            [whamlet|
                <p>Invalid input, let's try again.
                <form method=post action=@{PersonR} enctype=#{enctype}>
                    ^{widget}
                    <button>Submit
            |]





