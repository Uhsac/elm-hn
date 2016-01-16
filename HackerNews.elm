import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Jd exposing ((:=))
import Task exposing (Task)
import StartApp
import Effects exposing (Effects)
import String
import List

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
  []

formatStory : Story-> Story
formatStory story =
  Story
    story.title
    (story.url
      |> String.split "/"
      |> List.drop 2
      |> List.head
      |> Maybe.withDefault "")

init : Model -> (Model, Effects Action)
init model =
  ( model
  , fetchTopStoriesId
  )

-- View

header : Html
header =
  h1 [ headerStyle ] [ text "Hacker News" ]

item : Story -> Html
item story =
  let
    titleLink = href story.url
    formatedUrl =
      story.url
        |> String.split "/"
        |> List.drop 2
        |> List.head
        |> Maybe.withDefault ""
    addressLink = href ("http://" ++ formatedUrl)
  in
    li [ itemStyle ]
      [ a [ itemTitleStyle, titleLink ] [ text story.title ]
      , a [ itemAddressStyle, addressLink ] [ text formatedUrl ]
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
    [ ("color", "black")
    ]

itemAddressStyle : Attribute
itemAddressStyle =
  style
    [ ("float", "right")
    , ("opacity", ".6")
    , ("font-size", ".8em")
    , ("color", "black")
    ]

-- API

fetchTopStoriesId : Effects Action
fetchTopStoriesId =
  Http.get (Jd.list (Jd.map toString Jd.int)) hackerNewsTopStoriesEndpoint
    |> Task.toMaybe
    |> Task.map FetchTopStoriesId
    |> Effects.task

fetchStory : String -> Task Http.Error Story
fetchStory storyId =
  Http.get storyDecoder (hackerNewsItemEndpoint ++ storyId ++ ".json")

fetchTopStories : List String -> Effects Action
fetchTopStories topStoriesId =
  List.map fetchStory (List.take 3 topStoriesId)
    |> Task.sequence
    |> Task.toMaybe
    |> Task.map FetchTopStories
    |> Effects.task

-- Decoder

storyDecoder : Jd.Decoder Story
storyDecoder =
  Jd.object2 Story
    ("title" := Jd.string)
    ("url" := Jd.string)

-- Action

type Action
  = NoOp
  | FetchTopStoriesId (Maybe (List String))
  | FetchTopStories (Maybe (List Story))

-- Update

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp ->
      (model, Effects.none)

    FetchTopStoriesId maybeTopStoriesId ->
      ( model
      , fetchTopStories (Maybe.withDefault [] maybeTopStoriesId)
      )

    FetchTopStories maybeTopStories ->
      ( Maybe.withDefault [] maybeTopStories
      , Effects.none
      )

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
