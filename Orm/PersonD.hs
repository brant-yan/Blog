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
module Orm.PersonD where

import Database.Persist
import Database.Persist.TH
import Database.Persist.Sqlite
import Control.Monad.IO.Class(liftIO)
import Control.Monad.Trans.Resource




share [mkPersist sqlSettings, mkMigrate "migrateAll",mkSave "entityDefs"] [persistLowerCase|
    Person
        name String
        age Int
        deriving Show
|]
--main1 :: IO ()
--main1 = runSqlite "dev.sqlite3" $ do
--    runMigration $ migrate entityDefs $ entityDef (Nothing :: Maybe Person)
--    michaelId <- insert $ Person "Michael" 26
--    michael <- get michaelId
--    liftIO $ print michael

--runDb :: SqlPersist (ResourceT IO) a -> IO a
--runDb query = runSqlite "dev.sqlite3"  $ query
