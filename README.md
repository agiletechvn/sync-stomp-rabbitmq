## App

[![Demo](https://img.youtube.com/vi/Kur4gvJ5NTA/0.jpg)](https://www.youtube.com/watch?v=Kur4gvJ5NTA)

## JSON

```json
{
  "stories": [
    {
      "id": 47333,
      "title": "Site Design: Aquest",
      "vote_count": 6,
      "created_at": "2015-04-06T13:16:36Z",
      "num_comments": 6,
      "submitter_display_name": "Chris A.",
      "comments": [
        {
          "body": "Beautiful.",
          "created_at": "2015-04-06T13:45:20Z",
          "depth": 0,
          "user_display_name": "Sam M.",
          "upvotes_count": 0,
          "comments": []
        }
      ]
    }
  ]
}
```

```c
[Sync changes:JSON[@"stories"]
inEntityNamed:@"Story"
dataStack:dataStack
completion:^(NSError \*error) {
[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}];
```
