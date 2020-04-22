module Session exposing (Session, fromViewer, navKey)

import Browser.Navigation as Nav

-- TYPES

type Session = Guest Nav.Key


-- INFO

navKey : Session -> Nav.Key
navKey session =
    case session of
        Guest key ->
            key

-- CHANGES

fromViewer : Nav.Key -> Session
fromViewer key = Guest key