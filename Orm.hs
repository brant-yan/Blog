{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}
module Orm where

import Database.Persist
import Database.Persist.TH
import Database.Persist.Sqlite
import Control.Monad.IO.Class(liftIO)
import Control.Monad.Trans.Resource




share [mkPersist sqlSettings, mkMigrate "migrateAll",mkSave "entityDefs"] [persistLowerCase|
    Person
        name String
        password String
        lastLoginTime String
        deriving Show
    Blog
        personId    PersonId
        title String
        content String
        createTime  String
        deriving Show
    Evaluade
        blogId      BlogId
        level   String
        deriving Show
|]
initDatabase :: IO ()
initDatabase = runSqlite "dev.sqlite3" $ do
    runMigration $ migrate entityDefs $ entityDef (Nothing :: Maybe Evaluade)

--runDb :: SqlPersist (ResourceT IO) a -> IO a
--runDb query = runSqlite "dev.sqlite3"  $ query

--insertBlog::PersonId -> Entity Blog -> BlogId
--insertBlog personId blog= do
--            people <-  runDB $ selectList [PersonId ==. personId ] [LimitTo 1]
--            let persons = people::[Entity Person]
--            blogId <- runDB $ insert $ blog
--            blogId