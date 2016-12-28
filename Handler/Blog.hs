{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Blog where

import Data.Text as DT
import Orm

import Handler.Import
import Module.BlogM
import Snippet.BlogS





getWriteBlogR::Handler Html
getWriteBlogR = homepageDashboard $ do
             let content=newBlogWidget
             $(widgetFile "frame/center")


getReadBlogR :: BlogId ->  Handler Html
getReadBlogR blogId = homepageDashboard $ do
                     let content=blogWidget blogId
                     [whamlet|
                        <a href="#" onclick="window.history.back(-1);">后退
                     |]
                     $(widgetFile "frame/center")

postRecordBlogR::Handler Html
postRecordBlogR = do
            ((blogMessage , _),_) <- runFormPost blogForm
            case blogMessage of
                FormSuccess message -> do
                                Just name <- lookupCookie "login-name"
                                people <-  runDB $ selectList [PersonName ==. (DT.unpack name)] [LimitTo 1]
                                let persons = people::[Entity Person]
                                blogId <- runDB $ insert $ pid2blog (entityKey $ (Prelude.head) persons)
                                setMessage "文章保存成功"
                                redirect HomeR
                                    where
                                        pid2blog  :: PersonId -> Blog
                                        pid2blog pid = Blog pid (DT.unpack (title message)) (DT.unpack $ unTextarea (content message)) ( show (createTime message))
                _ -> do
                    setMessage "文章保存失败"
                    redirect HomeR
