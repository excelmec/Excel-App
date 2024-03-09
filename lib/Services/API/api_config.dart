// API config file

class APIConfig {
  // static final String baseUrl = 'https://staging.events.excelmec.org/api/';
   static final String baseUrl = 'https://events-api.excelmec.org/api/';
   static final String teamUrl = 'https://excel-team-backend.vercel.app/api/';
   static final String cabaseUrl = 'https://campus-ambassador-backend-xgveswperq-el.a.run.app/';
   static final String newsbaseUrl = 'https://excel-news-prod-api-qz5tnzui3q-as.a.run.app/news';
  //static final String baseUrl = 'https://events.excelmec.org/';

  static String getEndpoint(String category) {
    if (category == 'Competitions') return 'competition';
    if (category == 'General') return 'general';
    if (category == 'Talks') return 'talk';
    if (category == 'Workshops') return 'workshop';
    if (category == 'Conferences') return 'conference';
    return category;
  }
}
