import Html exposing (..)

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
  h1 [] [ text "Hacker News" ]

item : String -> Html
item title =
  li [] [ text title ]

itemList : Model -> Html
itemList model =
  let
    items = List.map item model
  in
    ul [] items

view : Model -> Html
view model =
  div []
    [ header
    , itemList model
    ]

main : Html
main =
  view model
