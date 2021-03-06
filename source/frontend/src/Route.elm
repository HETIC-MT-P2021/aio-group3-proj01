module Route exposing (Route(..), fromUrl, href, replaceUrl)


import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr

import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, oneOf, s, (</>), int)

-- ROUTING


type Route
    = Home
    | Root
    | NewImage
    | Tags
    | Categories
    | NewCategory
    | ImagesByCategory Int
    | ImagesByTag Int
    | ImageById Int
    | EditCategory Int
    | EditTag Int


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map NewImage (s "new")
        , Parser.map Tags (s "tags")
        , Parser.map Categories (s "categories")
        , Parser.map NewCategory (s "new-category")
        , Parser.map ImagesByCategory (s "category" </> int)
        , Parser.map ImagesByTag (s "tag" </> int)
        , Parser.map ImageById (s "image" </> int)
        , Parser.map EditCategory (s "edit-category" </> int)
        , Parser.map EditTag (s "edit-tag" </> int)
        ]


-- PUBLIC HELPERS


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    -- The RealWorld spec treats the fragment like a path.
    -- This makes it *literally* the path, so we can proceed
    -- with parsing as if it had been a normal path all along.
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser



-- INTERNAL


routeToString : Route -> String
routeToString page =
    "#/" ++ String.join "/" (routeToPieces page)


routeToPieces : Route -> List String
routeToPieces page =
    case page of
        Home ->
            []

        Root ->
            []

        NewImage ->
            [ "new" ]

        Tags ->
            [ "tags" ]

        Categories ->
            [ "categories" ]

        NewCategory ->
            [ "new-category" ]
        
        ImagesByCategory id ->
            [ "category", String.fromInt id]
        
        ImagesByTag id ->
            [ "tag", String.fromInt id]
        
        ImageById id ->
            [ "image", String.fromInt id]
        
        EditCategory id ->
            [ "edit-category", String.fromInt id]
        
        EditTag id ->
            [ "edit-tag", String.fromInt id]

        