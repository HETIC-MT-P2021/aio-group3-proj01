module Pages.About exposing (main, view, Msg)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = {name = "Edwin"}
        , view = view
        , update = update
        }

type alias Model =
    { name : String }


type Msg
    = ChangeName String

update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeName newName->
            {model | name = newName}


view : Model -> Html Msg
view model =
    div[][
        text ("Hello " ++ model.name),br[][],
        div[][text "If you want to know more about me, don't hesitate to contact me!"]
    ]

