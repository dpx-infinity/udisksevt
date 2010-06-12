-- udisksevt source file
-- Copyright (C) DPX-Infinity, 2010
-- Datatypes collection module

module UDisksEvt.Datatypes where

import Data.Map (Map)
import Control.Concurrent.STM (TVar)
import Text.ParserCombinators.Parsec (GenParser)

-- Main configuration datatype
data Configuration = C { cVars     :: Map String ConfigVarValue
                       , cTriggers :: Map String [ConfigTriggerAction]
                       }
                   deriving (Show)

-- Configuration variable value
data ConfigVarValue = CVString String
                    | CVBool Bool
                    | CVInt Int
                    deriving (Show, Eq)

-- Configuration trigger action - these commands definition
data ConfigTriggerAction = CTAShellCommand { ctascCommand :: String
                                           }
                         | CTANotification { ctanBody    :: String
                                           , ctanSummary :: String
                                           , ctanIcon    :: String
                                           , ctanTimeout :: Int	
                                           , ctanUrgency :: NotificationUrgency
                                           }
                         deriving (Show)

-- Notification urgency parameter
data NotificationUrgency = NULow                         
                         | NUNormal
                         | NUCritical
                         deriving (Show)

-- State type used in parsing
data ConfParserState = CPS { cpsCurrentTrigger :: Maybe String
                           , cpsConfiguration :: Configuration
                           }

-- Custom parser type with state
type ConfParser a = GenParser Char ConfParserState a

-- Device information structure, used for caching
data DeviceInfo = DInfo { diObjectPath :: String
                        , diDeviceFile :: String
                        , diMountPoint :: Maybe String
                        , diLabel      :: String
                        , diInternal   :: Bool
                        , diFSystem    :: Bool
                        } deriving (Show)

-- Global state datatype
data UState = U { uConfig :: Configuration
                , uDevices :: TVar (Map String DeviceInfo)
                }
