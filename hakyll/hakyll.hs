import Text.Hakyll
import Text.Hakyll.Render
import Text.Hakyll.Renderables
import Text.Hakyll.File
import Text.Hakyll.Regex
import Control.Monad.Reader (liftIO)
import System.Directory
import Control.Monad (mapM_, liftM)
import Data.List (sort)

main = hakyll $ do
    directory css "css"
    directory static "images"
    directory static "examples"
    directory static "reference"

    tutorials <- liftIO $ liftM (sort . filter (`matchesRegex` "^tutorial[0-9]*.markdown$")) $ getDirectoryContents "."
    let tutorialPage = createListing "tutorials.html"
                                     "templates/tutorialitem.html"
                                     (map createPagePath tutorials)
                                     [("title", "Tutorials")]
    renderChain ["templates/tutorials.html", "templates/default.html"] $ withSidebar tutorialPage

    mapM_ render' $ [ "about.markdown"
                    , "index.markdown"
                    , "philosophy.markdown"
                    , "reference.markdown"
                    , "changelog.markdown"
                    ] ++ tutorials

  where
    render' = renderChain ["templates/default.html"] . withSidebar . createPagePath
    withSidebar a = a `combine` createPagePath "sidebar.markdown"
          
