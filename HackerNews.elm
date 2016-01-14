import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Jd exposing ((:=))
import Task exposing (Task)
import StartApp
import Effects exposing (Effects)

-- Constant

hackerNewsTopStoriesEndpoint : String
hackerNewsTopStoriesEndpoint = "https://hacker-news.firebaseio.com/v0/topstories.json"

hackerNewsItemEndpoint : String
hackerNewsItemEndpoint = "https://hacker-news.firebaseio.com/v0/item/"

-- Type

type alias Story =
  { title : String
  , url : String
  }

-- Model

type alias Model = List Story

initialModel : Model
initialModel =
  [ {title = "Link 1", url = "http://google.com"}
  , {title = "Link 2", url = "http://google.com"}
  , {title = "Link 3", url = "http://google.com"}
  ]

init : Model -> (Model, Effects Action)
init model =
  ( model
  , Effects.none
  )

-- View

header : Html
header =
  h1 [ headerStyle ] [ text "Hacker News" ]

item : Story -> Html
item story =
  li [ itemStyle ]
    [ span [ itemTitleStyle ] [ text story.title ]
    , span [ itemAddressStyle ] [ text story.url ]
    ]

itemList : Model -> Html
itemList model =
  let
    items = List.map item model
  in
    ul [ itemListStyle ] items

view : Signal.Address Action -> Model -> Html
view address model =
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

itemTitleStyle : Attribute
itemTitleStyle =
  style
    [ ("", "")
    ]

itemAddressStyle : Attribute
itemAddressStyle =
  style
    [ ("float", "right")
    , ("opacity", ".6")
    , ("font-size", ".8em")
    ]

-- API
{-
fetchTopStories : Task Task.succeed (List String)
fetchTopStories =
  Http.get (Jd.list Jd.string) hackerNewsTopStoriesEndpoint
    |> Task.onError (\_ -> Task.succeed [])

fetchStory : String -> Task Task.succeed Story
fetchStory storyId =
  Http.get storyDecoder hackerNewsItemEndpoint ++ storyId ++ ".json"
    |> Task.onError (\_ -> Task.succeed {})
-}
-- Decoder

storyDecoder : Jd.Decoder Story
storyDecoder =
  Jd.object2 Story
    ("title" := Jd.string)
    ("url" := Jd.string)

-- Action

type Action
  = NoOp

-- Update

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp ->
      (model, Effects.none)

-- App

app = StartApp.start
  { init = init initialModel
  , update = update
  , view = view
  , inputs = []
  }

main = app.html

port tasks : Signal (Task Effects.Never ())
port tasks = app.tasks
