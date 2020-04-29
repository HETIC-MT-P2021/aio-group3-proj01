module Page.NewImage exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The image page. You can get here via either the / or /#/ routes.
-}

import Browser.Dom as Dom
import Html exposing (..)
import Html.Attributes exposing (class, type_, value, placeholder, style, id, for, method, action, name)
import Html.Events exposing (onClick ,onInput)
import Session exposing (Session)
import Task exposing (Task)
import File exposing (File)
import File.Select as Select
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder, int, string)
import Json.Encode exposing (encode, int, list, string)
import Json.Encode as Encode

-- MODEL

type alias Model =
    { 
        categories: List Category,
        error: Maybe String,
        session : Session,
        description: String,
        category_id: String,
        --tags: List Tag,
        image: Maybe File,
        name: String
    }

type alias Category = 
    {
        id: Int
        , name: String
    }

type alias Tag = 
    {
        data : List Category
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
            --, tags = []
            , image = Nothing
            , name = " "
        }
        , getCategories
        )

--- API
type ImagePart = 
    String
    | List

encode : Model -> List (String, Encode.Value)
encode model =
    [("description", Encode.string model.description)
    ,("category_id", Encode.string model.category_id)
    --,("tags", Encode.list model.tags)
    ,("name", Encode.string model.name)
    ]

save : Model -> Cmd Msg
save model =
  let
    body =
      case model.image of
        Nothing -> 
          Http.jsonBody (Encode.object [("image", Encode.object (encode model) ) ])
     
        Just file ->
            -- SHIT
            Http.multipartBody
                (Http.filePart "image" file
                :: List.map
                        (\( l, v ) ->
                            Http.stringPart (l) (Encode.encode 0 v)
                        )
                        (encode model)
                )
                            
                        
  in
  Http.post
    { url = "http://localhost:4000/api/image"
    , body = body
    , expect = Http.expectJson Saved Decode.int
    }


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
        let 
            imageBtn =
                case model.image of
                    Nothing ->
                            button [ onClick Image ] [ text "Add image" ]
                    Just image ->
                            button [ onClick ClearFile ] [ text ("Remove " ++ File.name image) ]
        in
        div []
            [ div [class "form-group"][label [for "image-field"] [text "Image"], imageBtn]
            , div [class "form-group"][label [for "name-field"] [text "Name"], viewInput "name" "form-control" "name-field" "text" "Name" model.name Name]
            , div [class "form-group"][label [for "category-field"] [text "Category"], viewCategoriesSelect model.categories CategoryMsg]
            --, div [class "form-group"][label [for "tags-field"] [text "Tags"],viewInput "tags" "form-control" "tags-field" "text" "Tags" (String.join "," model.tags) Tags]
            , div [class "form-group"][label [for "description-field"] [text "Description"],viewInput "description" "form-control" "description-field" "text" "Description" model.description Description]
            , button [class "btn btn-primary", onClick Save][text "Create"]
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

{-
view : Model -> {title : String, content : Html Msg}
view model =

    { title = "New image"
    , content =
        let 
            imageBtn =
                case model.image of
                    Nothing ->
                            button [ onClick Image ] [ text "Add image" ]
                    Just image ->
                            button [ onClick ClearFile ] [ text ("Remove " ++ File.name image) ]
        in
        div []
            [ label [] [ text "Name" ]
            , input [ type_ "text", value model.name, onInput ChangedName ] []
            , label [] [ text "Description" ]
            , input [ type_ "text", value model.description, onInput ChangedDescription ] []
            , label [] [ text "Category" ]
            , input [ type_ "text", value model.category, onInput ChangedCategory] []
            , label [] [ text "Tags" ]
            , input [ type_ "text", value model.tags, onInput ChangedTags ] []
            , imageBtn
            , button [ onClick Save ] [ text "Save" ]
            ]
    }
-}
-- UPDATE


type Msg = 
    GotSession Session
    | GotCategories (Result Http.Error (List Category))
    | Image
    | CategoryMsg String
    --| Tags String
    | Description String
    | Name String
    -- add image
    | FileSelected File
    | ClearFile
    | Save
    | Saved (Result Http.Error Int)
    | ChangedName String
    | ChangedDescription String
    | ChangedCategory String
    --| ChangedTags String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        Image ->
            ( model, Select.file [ "image/jpeg" ] FileSelected )

        CategoryMsg category_id ->
            ({model | category_id = category_id}, Cmd.none)

        Description description ->
            ({model | description = description}, Cmd.none)

        --Tags tags ->
            --({model | tags = String.split "," tags}, Cmd.none)

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

        -- Add image
        FileSelected f ->
            ( {model | image = Just f}, Cmd.none)

        ClearFile ->
            ( {model | image = Nothing}, Cmd.none)

        Save ->
            ( model, save model)

        Saved (Ok i) ->
            ( {model | image = Nothing}, Cmd.none)

        Saved (Err _) ->
            ( model, Cmd.none)

        ChangedName str ->
            ({ model | name = str}, Cmd.none)
            
        ChangedDescription str ->
            ({ model | description = str}, Cmd.none)

        ChangedCategory str ->
            ({ model | category_id = str}, Cmd.none)
        
        --ChangedTags str ->
            --({ model | tags = String.split "," str}, Cmd.none)



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