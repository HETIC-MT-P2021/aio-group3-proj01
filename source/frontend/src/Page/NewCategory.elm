module Page.NewCategory exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The image page. You can get here via either the / or /#/ routes.
-}

import Browser.Dom as Dom
import Html exposing (..)
import Html.Attributes exposing (class, type_, value, placeholder, style, id, for)
import Http exposing (..)
import Json.Encode as Encode
import Json.Decode as Decode exposing (Decoder, dict, field)
import Html.Events exposing (onInput, onClick)
import Session exposing (Session)
import Task exposing (Task)

-- MODEL

type alias Model =
    { 
        session : Session,
        name: String,
        received: String
    }

type alias Category = 
    {
        id: Int
        , name: String
    }

init : Session -> ( Model, Cmd Msg )
init session =
    (
    { 
        session = session
        , name = "",
        received = ""
    }
    , Cmd.none
    )

-- VIEW

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "New category"
    , content =
        div [ class "new-category-page" ]
            [ div [ class "container page" ]
                [ div [ class "row" ]
                    [viewForm model]
                ]
            ]
    }

viewForm : Model -> Html Msg
viewForm model =
  form []
    [ 
        div [class "form-group"][label [for "name-field"] [text "Name"], viewInput "form-control" "name-field" "text" "Name" model.name Name]
        , button [type_ "submit", class "btn btn-primary", onClick CreateCategory ][text "Create"]
        , viewValidation model
    ]

viewValidation : Model -> Html msg
viewValidation model =
  if String.length model.received > 1 then
    div [ style "color" "green" ] [ text "Category created" ]
  else 
    div [] []

viewInput: String -> String -> String -> String -> String -> (String -> msg) -> Html msg
viewInput c i t p v toMsg =
  input [ class c, id i, type_ t, placeholder p, value v, onInput toMsg ] []
-- UPDATE


type Msg = 
    GotSession Session
    | Name String
    | GotCategory (Result Http.Error (Category))
    | CreateCategory

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        Name name ->
            ({model | name = name}, Cmd.none)
        
        GotCategory category ->
            ({model | received = "ok"}, Cmd.none)
        
        CreateCategory ->
            (model, postCategory model)


-- HTTP

scrollToTop : Task x ()
scrollToTop =
    Dom.setViewport 0 0
        -- It's not worth showing the user anything special if scrolling fails.
        -- If anything, we'd log this to an error recording service.
        |> Task.onError (\_ -> Task.succeed ())


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- EXPORT

toSession : Model -> Session
toSession model =
    model.session

-- SUBMIT FORM

postCategory: Model -> Cmd Msg
postCategory model = 
    let
        body =
            Http.jsonBody <|
                    Encode.object
                        [ ( "categories", Encode.object
                            [ ( "name", Encode.string model.name ) ] ) ]
        headers = 
            []
    in
        Http.request
            { url = "http://localhost:4000/api/categories"
            , method = "POST"
            , body = body
            , expect = Http.expectJson GotCategory (Decode.field "data" (decodeCategory))
            , headers = headers
            , timeout = Nothing
            , tracker = Nothing
            }

decodeCategory : Decoder Category
decodeCategory =
   Decode.map2 Category
     (Decode.field "id" Decode.int)
     (Decode.field "name" Decode.string)