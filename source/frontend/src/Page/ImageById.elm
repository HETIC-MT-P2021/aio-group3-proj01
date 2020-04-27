module Page.ImageById exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Browser.Dom as Dom
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (class, value, src)
import Html.Events exposing (onInput, onClick)

import Session exposing (Session)
import Task exposing (Task)
import Route exposing (Route)

import Browser exposing (sandbox)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder, int, string, field)

-- MODEL

type alias Model =
    { 
        session : Session
        , image: Maybe Image
        , error : Maybe String
        , id: Int
    }

type alias Image =
    { id : Int
    , name : String
    , description : String
    , image_original_url : String
    }


decodeImage : Decoder Image
decodeImage =
   Decode.map4 Image
     (Decode.field "id" Decode.int)
     (Decode.field "name" Decode.string)
     (Decode.field "description" Decode.string)
     (Decode.field "image_original_url" Decode.string)

type Msg = 
    GotImages (Result Http.Error (Image))
    | DeleteMsg Int
    | DeletedMsg (Result Http.Error ())

init : Session -> Int -> ( Model, Cmd Msg )
init session id =
    (
    { 
        session = session
        , image = Nothing
        , error = Nothing
        , id = id
    }
    , getImages id
    )
getImages : Int -> Cmd Msg
getImages id =
    Http.get
        { url = "http://localhost:4000/api/image/" ++ (String.fromInt id)
        , expect = Http.expectJson GotImages (Decode.field "data" (decodeImage))
        }


-- VIEW

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Image by id"
    , content =      
            div [class "container page"] [  
                div [class "buttons"] [
                    a [class "btn btn-primary", Route.href Route.Home][text "Edit"]
                    , button[class "btn btn-danger", onClick (DeleteMsg model.id)][text "Delete"]
                ],
                case model.error of
                    Nothing ->
                        case model.image of
                            Just image ->
                                viewImage image

                            Nothing ->
                                div [][text "no image found"]

                    Just error ->
                        div [ ]
                            [ h1 [] [ text error ] ]
            ]
    }

viewImage : Image -> Html Msg
viewImage image =
    div [class "image-full"] [
        img [src ("http://localhost:4000" ++ image.image_original_url)][]
        , div [class "card-details"] [
            h1 [class "name"] [text image.name]
            , p [class "card-text"] [text image.description]
        ]
    ]

-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotImages (Ok image) ->
            ( { model
                | image = Just image
                , error = Nothing
              }
            , Cmd.none
            )

        GotImages (Err err) ->
            let
                _ =
                    Debug.log "An error occured" err
            in
            ( { model
                | error = Just <| errorToString err
                , image = Nothing
              }
            , Cmd.none
            )
        
        DeleteMsg id ->
            (model, deleteImage id)

        DeletedMsg _ ->
            (model, Nav.reload)



-- HTTP

scrollToTop : Task x ()
scrollToTop =
    Dom.setViewport 0 0
        -- It's not worth showing the user anything special if scrolling fails.
        -- If anything, we'd log this to an error recording service.
        |> Task.onError (\_ -> Task.succeed ())

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



-- HTTP 

deleteImage: Int -> Cmd Msg
deleteImage id = 
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "http://localhost:4000/api/image/" ++ String.fromInt id
        , body = Http.emptyBody
        , expect = Http.expectWhatever DeletedMsg
        , timeout = Nothing
        , tracker = Nothing
        }

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- EXPORT

toSession : Model -> Session
toSession model =
    model.session

