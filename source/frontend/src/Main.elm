module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Url exposing (Url)

import Page exposing (Page)
import Page.Home as Home
import Page.NewImage as NewImage
import Page.Tags as Tags
import Page.Categories as Categories
import Page.Blank as Blank
import Page.NotFound as NotFound

import Route exposing (Route)
import Session exposing (Session)

type Model
    = Redirect Session
    | NotFound Session
    | Home Home.Model
    | NewImage NewImage.Model
    | Categories Categories.Model
    | Tags Tags.Model

-- MODEL

init : Int -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.fromViewer navKey))

-- MAIN

main : Program Int Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }

-- VIEW


view : Model -> Document Msg
view model =
    let
        viewPage page toMsg config =
            let
                { title, body } =
                    Page.view page config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        Redirect _ ->
            Page.view Page.Other Blank.view

        NotFound _ ->
            Page.view Page.Other NotFound.view

        NewImage newImage ->
            viewPage Page.NewImage NewImageMsg (NewImage.view newImage)

        Home home ->
            viewPage Page.Home HomeMsg (Home.view home)

        Tags tags ->
            viewPage Page.Tags TagsMsg (Tags.view tags)

        Categories categories ->
            viewPage Page.Categories CategoriesMsg (Categories.view categories)


-- UPDATE


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | HomeMsg Home.Msg
    | NewImageMsg NewImage.Msg
    | CategoriesMsg Categories.Msg
    | TagsMsg Tags.Msg

toSession : Model -> Session
toSession page =
    case page of
        Redirect session ->
            session

        NotFound session ->
            session

        Home home ->
            Home.toSession home

        NewImage newImage ->
            NewImage.toSession newImage

        Categories categories ->
            Categories.toSession categories

        Tags tags ->
            Tags.toSession tags


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Nothing ->
            ( NotFound session, Cmd.none )

        Just Route.Root ->
            ( model, Route.replaceUrl (Session.navKey session) Route.Home )

        Just Route.Home ->
            Home.init session
                |> updateWith Home HomeMsg model

        Just Route.NewImage ->
            NewImage.init session
                |> updateWith NewImage NewImageMsg model

        Just Route.Tags ->
            Tags.init session
                |> updateWith Tags TagsMsg model

        Just Route.Categories ->
            Categories.init session
                |> updateWith Categories CategoriesMsg model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            -- If we got a link that didn't include a fragment,
                            -- it's from one of those (href "") attributes that
                            -- we have to include to make the RealWorld CSS work.
                            --
                            -- In an application doing path routing instead of
                            -- fragment-based routing, this entire
                            -- `case url.fragment of` expression this comment
                            -- is inside would be unnecessary.
                            ( model, Cmd.none )

                        Just _ ->
                            ( model
                            , Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url)
                            )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

       
        ( HomeMsg subMsg, Home home ) ->
            Home.update subMsg home
                |> updateWith Home HomeMsg model

        ( NewImageMsg subMsg, NewImage newImage ) ->
            NewImage.update subMsg newImage
                |> updateWith NewImage NewImageMsg model

        ( TagsMsg subMsg, Tags tags ) ->
            Tags.update subMsg tags
                |> updateWith Tags TagsMsg model

        ( CategoriesMsg subMsg, Categories categories ) ->
            Categories.update subMsg categories
                |> updateWith Categories CategoriesMsg model

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        NotFound _ ->
            Sub.none

        Redirect _ ->
            Sub.none

        NewImage newImage ->
            Sub.map NewImageMsg (NewImage.subscriptions newImage)

        Home home ->
            Sub.map HomeMsg (Home.subscriptions home)

        Categories categories ->
            Sub.map CategoriesMsg (Categories.subscriptions categories)

        Tags tags ->
            Sub.map TagsMsg (Tags.subscriptions tags)