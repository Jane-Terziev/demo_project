SELECT posts.*, COUNT(comments.id) AS number_of_comments
FROM posts
LEFT JOIN comments ON posts.id = comments.post_id AND comments.archived = false
WHERE posts.archived = false
GROUP BY posts.id