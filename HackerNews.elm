import Html exposing (..)
import Html.Attributes exposing (..)

-- Model

type alias Model = List String

model : Model
model =
  [ "Link 1"
  , "Link 2"
  , "Link 3"
  ]

-- View

header : Html
header =
  h1 [ headerStyle ] [ text "Hacker News" ]

item : String -> Html
item title =
  li [ itemStyle ] [ text title ]

itemList : Model -> Html
itemList model =
  let
    items = List.map item model
  in
    ul [ itemListStyle ] items

view : Model -> Html
view model =
  div [ viewStyle ]
    [ header
    , itemList model
    ]

-- Style

viewStyle : Attribute
viewStyle =
  style
    [ ("width", "80%")
    , ("background-color", "#ff6600")
    , ("margin", "auto")
    ]

headerStyle : Attribute
headerStyle =
  style
    [ ("text-align", "center")
    , ("margin", "0")
    , ("padding", ".2em")
    ]

itemListStyle : Attribute
itemListStyle =
  style
    [ ("background-color", "#f6f6ef")
    , ("margin", "0")
    , ("padding", ".2em")
    ]

itemStyle : Attribute
itemStyle =
  style
    [ ("list-style", "none")
    , ("margin", "1em")
    ]

main : Html
main =
  view model
