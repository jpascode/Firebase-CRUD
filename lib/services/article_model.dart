

class Article{

  final String id, title, description, user_id, image_url;

  final DateTime create_at,update_at;


  Article({required this.id, required this.title, required this.description, required this.image_url, required this.create_at, required this.update_at, required this.user_id});


  toMap(Article article){
    return {
      "id": article.id,
      "title":article.title,
      "description":article.description,
      "image_url":article.image_url,
      "create_at":article.create_at,
      "update_at":article.update_at,
      "user_id":article.user_id
    };
  }
}