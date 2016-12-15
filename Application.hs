{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}

{-# OPTIONS_GHC -fno-warn-orphans #-}
module Application where

import Foundation
import Yesod.Core

import Handler.Home
import Handler.Help
import Handler.Login
import Handler.Register
import Handler.Blog
import Handler.Page

mkYesodDispatch "App" resourcesApp
