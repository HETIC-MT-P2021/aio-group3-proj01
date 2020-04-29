module Page exposing (Page(..), view, viewErrors)

import Browser exposing (Document)
import Html exposing (Html, a, button, div, footer, i, img, li, br, nav, p, span, text, ul)
import Html.Attributes exposing (class, classList, href, style)
import Html.Events exposing (onClick)

import Route exposing (Route)

{-| Determines which navbar link (if any) will be rendered as active.
Note that we don't enumerate every page here, because the navbar doesn't
have links for every page. Anything that's not part of the navbar falls
under Other.
-}
type Page
    = Other
    | Home
    | NewImage
    | Tags
    | Categories
    | NewCategory
    | ImagesByCategory
    | ImagesByTag
    | ImageById
    | EditCategory
    | EditTag


{-| Take a page's Html and frames it with a header and footer.
The caller provides the current user, so we can display in either
"signed in" (rendering username) or "signed out" mode.
isLoading is for determining whether we should show a loading spinner
in the header. (This comes up during slow page transitions.)
-}
view : Page -> { title : String, content : Html msg } -> Document msg
view page { title, content } =
    { title = title ++ " - Gallery."
    , body = viewHeader page :: content :: [ viewFooter ]
    }


viewHeader : Page -> Html msg
viewHeader page =
    nav [ class "navbar navbar-expand-lg navbar-light bg-light" ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", Route.href Route.Home ]
                [ text "Gallery." ]
            , br[][]
            , ul [ class "nav navbar-nav pull-xs-right" ] <|
                navbarLink page Route.Home [ text "Home" ]
                    :: viewMenu page
            ]
        ]



viewMenu : Page -> List (Html msg)
viewMenu page =
    let
        linkTo =
            navbarLink page
    in
        [ linkTo Route.NewImage [ i [ class "ion-gear-a" ] [], text "\u{00A0}New Image" ]
        , linkTo Route.Categories [ i [ class "ion-gear-a" ] [], text "\u{00A0}Categories" ]
        , linkTo Route.Tags [ i [ class "ion-gear-a" ] [], text "\u{00A0}Tags" ]
        ]


viewFooter : Html msg
viewFooter =
    footer [ class "footer"]
        [ div [ class "container" ]
            [ a [ class "logo-font", href "/" ] [ text "Gallery." ]
            , span [ class "attribution" ]
                [ text "An interactive learning project from "
                , a [ href "https://github.com/HETIC-MT-P2021/aio-group3-proj01" ] [ text "HETIC group 3" ]
                , text ". Code & design licensed under MIT."
                ]
            ]
        ]


navbarLink : Page -> Route -> List (Html msg) -> Html msg
navbarLink page route linkContent =
    li [ classList [ ( "nav-item", True ), ( "active", isActive page route ) ] ]
        [ a [ class "nav-link", Route.href route ] linkContent ]


isActive : Page -> Route -> Bool
isActive page route =
    case ( page, route ) of
        ( Home, Route.Home ) ->
            True

        ( NewImage, Route.NewImage ) ->
            True

        ( Tags, Route.Tags ) ->
            True

        ( Categories, Route.Categories ) ->
            True

        _ ->
            False


{-| Render dismissable errors. We use this all over the place!
-}
viewErrors : msg -> List String -> Html msg
viewErrors dismissErrors errors =
    if List.isEmpty errors then
        Html.text ""

    else
        div
            [ class "error-messages"
            , style "position" "fixed"
            , style "top" "0"
            , style "background" "rgb(250, 250, 250)"
            , style "padding" "20px"
            , style "border" "1px solid"
            ]
        <|
            List.map (\error -> p [] [ text error ]) errors
                ++ [ button [ onClick dismissErrors ] [ text "Ok" ] ]