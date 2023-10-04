# READX

### Workflow

1. Collect stories (from Google)
   - use [ValueSerp](https://www.valueserp.com/) API
   - [code](./app/models/concerns/stories/collectable.rb)
2. Scrape story's full text
   - [code](./app/models/concerns/stories/scrapable.rb)
3. Analyze stories (using ChatGPT)
   - [code](./app/models/concerns/stories/analyzable.rb)
   - summary
   - fact/opinion
   - score
   - sentiment
   - tags
   - locale
4. Translate story (using ChatGPT)
   - [code](./app/models/translation.rb)
5. Classfiy story (using ChatGPT)
   - [code](./app/models/concerns/stories/classifiable.rb)
   - Embedding
   - Classify the stories with the same topic(like embedding cosine distance < 0.15)
