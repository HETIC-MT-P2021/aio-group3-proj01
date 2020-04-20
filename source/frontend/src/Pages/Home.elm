module Pages.Home exposing (main, view, Msg, update)

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
        input[onInput ChangeName, value model.name][]
    ]
