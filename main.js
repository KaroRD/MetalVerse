import express from "express";
import bodyParser from "body-parser";
import axios from "axios";
import dotenv from "dotenv";

const app = express();
const port = 3000;
app.set("view engine", "ejs"); // Set EJS as the template engine

app.use(express.static("public"));
app.use(bodyParser.urlencoded({ extended: true }));

dotenv.config();

const API_KEY = process.env.NEWS_API_KEY;
const query = encodeURIComponent(
  '("metal music" OR "Rock music")AND("heavy metal" OR "rock music" OR "metal band" OR "rock band" OR "metal album" OR "metal concert") NOT("politics" OR "food" OR "elon musk " OR "invest" OR "crypto" OR "Rap" )'
);


const queryTop = encodeURIComponent(
  '(("heavy metal" AND "band") OR "metal band" OR ("hard rock" AND music))'
);

const API_URL = `https://newsapi.org/v2/everything?q=${query}&searchIn=title,description&language=en&sortBy=publishedAt&apiKey=${API_KEY}`;
const API_URL_TOP3 = `https://newsapi.org/v2/everything?q=${queryTop}&searchIn=title,description&language=en&sortBy=popularity&pageSize=3&apiKey=${API_KEY}`;
const MUSICBRAINZ_ARTIST_URL = "https://musicbrainz.org/ws/2/artist/";

// Utility function to fetch data NEWS
async function fetchData(url, headers = {}) {
  try {
    const response = await axios.get(url, { headers, timeout: 10000 });
    return response.data;
  } catch (error) {
    if (error.response) {
      // Log detailed information from the API response
      console.error("Error fetching data:", error.response.data);
      if (error.response.status === 429) {
        console.error("Rate limit exceeded: Too many requests.");
        return { error: "Rate limit exceeded", status: 429 };
      }
      //for other statuses
      return {
        error: `Error: ${error.response.status} - ${error.response.statusText}`,
        status: error.response.status,
      };
    } else {
      // Log errors that occur before the API responds (e.g., network issues)
      console.error("Error fetching data:", error.message);
      return { error: error.message };
    }
  }
}


app.get("/", function (req, res) {
  res.render("home.ejs");
});

app.get("/home", function (req, res) {
  res.redirect("/");
});

app.get("/forum", function (req, res) {
  res.render("forum.ejs");
});

app.post("/forum", function (req, res) {
  res.render("forum.ejs");
});

app.get("/about", function (req, res) {
  res.render("about.ejs");
});

app.get("/news", async function (req, res) {
  try {
    // Fetch news data asynchronously
    const newsData = await fetchData(API_URL); // Assuming fetchData() returns data from the News API
    const carouselNews = await fetchData(API_URL_TOP3); // Assuming fetchData() returns data from the News API

    if (
      (newsData.status && newsData.status === 429) ||
      (carouselNews.status && carouselNews.status === 429)
    ) {
      console.error("Rate limit exceeded - rendering crash.ejs");
      return res.render("crash.ejs", {
        error: "Rate limit exceeded. Please try again later.",
      });
    }

    // Pass the fetched data to the EJS template
    res.render("news.ejs", { news: newsData, topNews: carouselNews });
  } catch (error) {
    res.render("crash.ejs");
    console.error("Error fetching news:", error);
    res.status(500).send("Error fetching news data");
  }
});

app.get("/album", function (req, res) {
  res.render("album.ejs");
});

app.get("/bands", function(req, res){
  res.render("bands.ejs");

});




app.get("/concerts", function (req, res) {
  res.render("concerts.ejs");
});

app.listen(port, function () {
  console.log("I'm Here!!");
});
