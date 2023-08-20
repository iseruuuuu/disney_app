import 'package:disney_app/core/firebase/firebase.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<Post>()])
class FakePost {
  Post post() {
    return Post(
      id: '1',
      content: 'content',
      postAccountId: 'post_account_id',
      createdTime: Timestamp.now(),
      rank: 5,
      attractionName: 'attraction_name',
      isSpoiler: true,
    );
  }

  List<String> mockIds = ['1', '2', '3'];

  final List<Post> _mockPosts = [
    Post(
      id: '1',
      content: 'content',
      postAccountId: 'post_account_id',
      createdTime: Timestamp.now(),
      rank: 5,
      attractionName: 'attraction_name',
      isSpoiler: true,
    ),
    Post(
      id: '2',
      content: 'content2',
      postAccountId: 'post_account_id2',
      createdTime: Timestamp.now(),
      rank: 5,
      attractionName: 'attraction_name2',
      isSpoiler: true,
    ),
    Post(
      id: '3',
      content: 'content3',
      postAccountId: 'post_account_id3',
      createdTime: Timestamp.now(),
      rank: 5,
      attractionName: 'attraction_name3',
      isSpoiler: true,
    ),
  ];

  List<Post> get mockPosts => _mockPosts;

  String mockAccountId = 'test';

  List<String> mockGetPostsFromIds = ['id1', 'id2'];

  final userPostData = {'title': 'User Post'};
}
