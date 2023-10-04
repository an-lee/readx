# READX

### Workflow

1. Collect stories (from Google)
   - use [ValueSerp](https://www.valueserp.com/) API
2. Scrape story's full text
3. Analyze stories (using ChatGPT)
   - summary
   - fact/opinion
   - score
   - sentiment
   - tags
   - locale
4. Translate story (using ChatGPT)
5. Classfiy story (using ChatGPT)
   - Embedding
   - Classify the stories with the same topic(like embedding cosine distance < 0.15)
