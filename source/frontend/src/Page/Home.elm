module Page.Home exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Browser.Dom as Dom
import Html exposing (..)
import Html.Attributes exposing (class, value, src)
import Html.Events exposing (onInput)

import Session exposing (Session)
import Task exposing (Task)

-- MODEL

type alias Model =
    { 
        session : Session
        , images: List Image
    }

type alias Image =
    { src : String
    , description : String
    }

init : Session -> ( Model, Cmd Msg )
init session =
    (
    { 
        session = session
        , images = [
            {src = "https://thebarkingboutique.com/wp-content/uploads/2019/11/image-1.jpg", description = "This is a cute dog."}
            , {src = "https://cdn.mos.cms.futurecdn.net/VSy6kJDNq2pSXsCzb6cvYF.jpg", description = "This is a beautiful cat."}
            , {src = "https://cdn.mos.cms.futurecdn.net/VSy6kJDNq2pSXsCzb6cvYF.jpg", description = "This is a beautiful cat."}
            , {src = "https://cdn.mos.cms.futurecdn.net/VSy6kJDNq2pSXsCzb6cvYF.jpg", description = "This is a beautiful cat."}
        ]
    }
    , Cmd.none
    )

-- VIEW

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Home"
    , content =
        div [ class "home-page" ]
            [ div [ class "container page" ]
                [ 
                    viewImages model.images
                ]
            ]
    }

viewImages: List Image -> Html Msg
viewImages images = 
    div [ class "images-list" ] (List.map viewImage images)

viewImage: Image -> Html Msg
viewImage image = 
    div [class "card"] [
        img [src image.src, class "card-img-top"][]
        , div [class "card-body"] [
            p [class "card-text"] [text image.description]
        ]
    ]

-- UPDATE


type Msg = 
    GotSession Session

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )


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