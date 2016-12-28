{-# LANGUAGE OverloadedStrings,FlexibleContexts #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE PackageImports, ConstraintKinds #-}
module Module.EvaluateM where

import Foundation

import  Control.Applicative ((<$>), (<*>))
import  Yesod
import  Yesod.Form.Jquery

import Data.Text (Text,pack)
import Settings

import Data.Text.Encoding(decodeUtf8)
import Yesod.Core.Handler
import Orm

import "esqueleto" Database.Esqueleto as E
import "monad-logger" Control.Monad.Logger (MonadLogger)
import "resourcet" Control.Monad.Trans.Resource (MonadResourceBase)

{- 提供用户写blog的页面对应项-}

data EvaluateMessage = EvaluateMessage{ blogId :: BlogId
                                      , level :: Int
                                      } deriving Show


evaluateForm :: BlogId -> Html -> MForm Handler (FormResult EvaluateMessage, Widget)
evaluateForm bId html = flip  renderDivs html $ EvaluateMessage
                            <$> areq hiddenField "" (Just bId)
                            <*> areq (radioFieldList [( pack "不喜欢", 1),( "一般",2),("喜欢",3)]) "打分" (Just (2))

evaluateFormT ::  Html -> MForm Handler (FormResult EvaluateMessage, Widget)
evaluateFormT = renderDivs $ EvaluateMessage
                            <$> areq hiddenField "" Nothing
                            <*> areq (radioFieldList [( pack "不喜欢", 1),( "一般",2),("喜欢",3)]) "打分" (Just (2))

evaluateLevel1 :: ( MonadLogger m , MonadResourceBase m) => E.SqlPersist  m [(E.Value BlogId, E.Value Int)]
evaluateLevel1 = do
            E.select
            $ E.from $ \t  -> do
                    return (t E.^. EvaluateBlogId, t E.^. EvaluateLevel )