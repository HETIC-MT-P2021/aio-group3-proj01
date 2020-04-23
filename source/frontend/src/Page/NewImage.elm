module Page.NewImage exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The image page. You can get here via either the / or /#/ routes.
-}

import Browser.Dom as Dom
import Html exposing (..)
import Html.Attributes exposing (class, type_, value, placeholder, style, id, for)
import Html.Events exposing (onInput)
import Session exposing (Session)
import Task exposing (Task)

-- MODEL

type alias Model =
    { 
        session : Session,
        description: String,
        category: String,
        tags: String,
        image: String
    }

init : Session -> ( Model, Cmd Msg )
init session =
    (
    { 
        session = session
        , description = ""
        , category = ""
        , tags = ""
        , image = ""
    }
    , Cmd.none
    )

-- VIEW

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "New image"
    , content =
        div [ class "new-image-page" ]
            [ div [ class "container page" ]
                [ div [ class "row" ]
                    [viewForm model]
                ]
            ]
    }

viewForm : Model -> Html Msg
viewForm model =
  form []
    [ div [class "form-group"][label [for "image-field"] [text "Image"], viewInput "form-control" "image-field" "file" "Image" model.image Image]
    , div [class "form-group"][label [for "category-field"] [text "Category"], viewInput "form-control" "category-field" "text" "Category" model.category Category]
    , div [class "form-group"][label [for "tags-field"] [text "Tags"],viewInput "form-control" "tags-field" "text" "Tags" model.tags Tags]
    , div [class "form-group"][label [for "description-field"] [text "Description"],viewInput "form-control" "description-field" "text" "Description" model.description Description]
    , button [type_ "submit", class "btn btn-primary"][text "Create"]
    , viewValidation model
    ]

viewValidation : Model -> Html msg
viewValidation model =
  if String.length model.category > 1 then
    div [ style "color" "green" ] [ text "OK" ]
  else
    div [ style "color" "red" ] [ text "You must choose a category!" ]

viewInput: String -> String -> String -> String -> String -> (String -> msg) -> Html msg
viewInput c i t p v toMsg =
  input [ class c, id i, type_ t, placeholder p, value v, onInput toMsg ] []
-- UPDATE


type Msg = 
    GotSession Session
    | Image String
    | Category String
    | Tags String
    | Description String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        Image image ->
            ({model | image = image}, Cmd.none)

        Category category ->
            ({model | category = category}, Cmd.none)

        Description description ->
            ({model | description = description}, Cmd.none)

        Tags tags ->
            ({model | tags = tags}, Cmd.none)


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