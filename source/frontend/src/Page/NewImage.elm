module Page.NewImage exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The image page. You can get here via either the / or /#/ routes.
-}

import Browser.Dom as Dom
import Html exposing (..)
import Html.Attributes exposing (class, type_, value, placeholder, style, id, for, method, action, name)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder, int, string)

import Html.Events exposing (onInput)
import Session exposing (Session)
import Task exposing (Task)

-- MODEL

type alias Model =
    { 
        categories: List Category,
        error: Maybe String,
        session : Session,
        description: String,
        category_id: String,
        tags: String,
        image: String,
        name: String
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
        , categories = []
        , error = Nothing
        , description = ""
        , category_id = ""
        , tags = ""
        , image = ""
        , name = " "
    }
    , getCategories
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
  form [method "POST", action "http://localhost:4000/api/image"]
    [ div [class "form-group"][label [for "image-field"] [text "Image"], viewInput "image" "form-control" "image-field" "file" "Image" model.image Image]
    , div [class "form-group"][label [for "name-field"] [text "Name"], viewInput "name" "form-control" "name-field" "text" "Name" model.name Name]
    , div [class "form-group"][label [for "category-field"] [text "Category"], viewCategoriesSelect model.categories CategoryMsg]
    , div [class "form-group"][label [for "tags-field"] [text "Tags"],viewInput "tags" "form-control" "tags-field" "text" "Tags" model.tags Tags]
    , div [class "form-group"][label [for "description-field"] [text "Description"],viewInput "description" "form-control" "description-field" "text" "Description" model.description Description]
    , button [type_ "submit", class "btn btn-primary"][text "Create"]
    , viewValidation model
    ]

viewValidation : Model -> Html msg
viewValidation model =
  if String.length model.category_id >0 then
    div [ style "color" "green" ] [ text "OK" ]
  else
    div [ style "color" "red" ] [ text "You must choose a file and a category!" ]

viewInput: String -> String -> String -> String -> String -> String -> (String -> msg) -> Html msg
viewInput n c i t p v toMsg =
  input [ name n, class c, id i, type_ t, placeholder p, value v, onInput toMsg ] []

viewCategoriesSelect: List Category -> (String -> msg) -> Html msg
viewCategoriesSelect categories toMsg = 
    select [class "form-control", id "category-field", name "category_id", onInput toMsg] (List.map viewOption categories)
viewOption: Category -> Html msg
viewOption category = 
    option [value (String.fromInt category.id)] [text category.name]

-- UPDATE


type Msg = 
    GotSession Session
    | GotCategories (Result Http.Error (List Category))
    | Image String
    | CategoryMsg String
    | Tags String
    | Description String
    | Name String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        Image image ->
            ({model | image = image}, Cmd.none)

        CategoryMsg category_id ->
            ({model | category_id = category_id}, Cmd.none)

        Description description ->
            ({model | description = description}, Cmd.none)

        Tags tags ->
            ({model | tags = tags}, Cmd.none)

        Name name ->
            ({model | name = name}, Cmd.none)
        
        GotCategories (Ok categories) ->
            ( { model
                | categories = categories
                , error = Nothing
              }
            , Cmd.none
            )

        GotCategories (Err err) ->
            let
                _ =
                    Debug.log "An error occured" err
            in
            ( { model
                | error = Just <| errorToString err
                , categories = []
              }
            , Cmd.none
            )


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


-- HTTP & DECODE

getCategories : Cmd Msg
getCategories =
    Http.get
        { url = "http://localhost:4000/api/categories"
        , expect = Http.expectJson GotCategories (Decode.field "data" (Decode.list decodeCategory))
        }

decodeCategory : Decoder Category
decodeCategory =
   Decode.map2 Category
     (Decode.field "id" Decode.int)
     (Decode.field "name" Decode.string)


errorToString : Http.Error -> String
errorToString error =
    case error of
        BadUrl url ->
            "Bad url: " ++ url

        Timeout ->
            "Request timed out."

        NetworkError ->
            "Network error. Are you online?"

        BadStatus status_code ->
            "HTTP error " ++ String.fromInt status_code

        BadBody body ->
            "Unable to parse response body: " ++ body
