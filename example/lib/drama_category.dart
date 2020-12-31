import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:logging/logging.dart';
import 'package:image_provider/image_provider.dart' as img_provider;
import 'api_response.dart';
import 'datetime.dart';
import 'drama.dart';
import 'drama_repository.dart';
import 'network.dart';

final logger = Logger('DramaCategory');

class DramaCategory extends StatefulWidget {
  final List<String> categories = [
    "犯罪/历史",
    "魔幻/科幻",
    "惊悚/灵异",
    "都市/情感",
    "选秀/综艺",
    "动漫/卡通",
  ];

  @override
  _DramaCategoryState createState() {
    return _DramaCategoryState();
  }
  DramaCategory({Key key}) : super(key: key);
}

class _DramaCategoryState extends State<DramaCategory> {

  @override
  void initState() {
    logger.info("dramaCategory=>initState");
    super.initState();
  }

  @override
  void didUpdateWidget(DramaCategory oldWidget) {
    logger.info("dramaCategory=>didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    logger.info("dramaCategory=>reassemble");
    super.reassemble();
  }

  @override
  void deactivate() {
    logger.info("dramaCategory=>deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    logger.info("dramaCategory=>dispose");
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    logger.info("dramaCategory=>didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: widget.categories.length,
        child: Builder(
          builder: (context) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      pinned: true,
                      snap: false,
                      floating: false,
                      forceElevated: innerBoxIsScrolled,
                      title: Text('image_provider'),
                      bottom: TabBar(
                          isScrollable: true,
                          labelStyle: Theme.of(context).textTheme.headline6,
                          unselectedLabelStyle:
                              Theme.of(context).textTheme.bodyText1,
                          tabs: widget.categories
                              .map((tab) => Tab(text: tab))
                              .toList()))
                ];
              },
              body: TabBarView(
                  children: widget.categories.map((tab) {
                logger.info('**************$tab');
                return DramaList(tab);
              }).toList())),
        ));
  }
}

class DramaList extends StatefulWidget {
  final String category;

  DramaList(this.category, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    logger.info('createState: $category');
    return _DramaListState();
  }

}

class _DramaListState extends State<DramaList>
    with AutomaticKeepAliveClientMixin<DramaList> {
  List<Drama> _dramas = [];
  int _page = 1;
  int _maxPage = 1;
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isPaging = false;
  Object _error;

  bool get _hasData => _dramas.isNotEmpty;

  bool get _hasError => _error != null;

  @override
  void initState() {
    logger.info("initState");
    super.initState();

    _isLoading = true;
   _getDramasFuture(_page).then((Dramas data) {
      if (!mounted) return;
      _maxPage = data.meta.pages;
      _dramas.addAll(data.dramas);
      _error = data.meta.total > 0 ? null : "没有任何内容";
    }).catchError((e) {
      if (!mounted) return;
      _error = e;
    }).whenComplete(() {
     if (!mounted) return;
     _isLoading = false;
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(DramaList oldWidget) {
    logger.info("didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    logger.info("reassemble");
    super.reassemble();
  }

  @override
  void deactivate() {
    logger.info("deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    logger.info("dispose");
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    logger.info("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;

  Future<Dramas> _getDramasFuture(int page,
      {LoadingState state = LoadingState.def}) {
    return dramaRepo.getDramas(page, widget.category, state: state);
  }

  _onLoadMore() {
    setState(() {
      _isPaging = true;
    });
    _getDramasFuture(_page + 1, state: LoadingState.more).then((Dramas data) {
      if (!mounted) return;
      _dramas.addAll(data.dramas);
      _page++;
      _error = null;
    }).catchError((e) {
      if (!mounted) return;
      _error = e;
    }).whenComplete(() {
      if (!mounted) return;
      _isPaging = false;
      setState(() {});
    });
  }

  bool _onScrollEnd(ScrollEndNotification notification) {
    if (notification.metrics.extentAfter == 0) {
      if (_page >= _maxPage || _isPaging) {
        logger.info('The end or is paging ****************');
        return false;
      }
      _onLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildContent();
  }

  Widget _buildContent() {
    Widget content;
    if (_hasData) {
      content = NotificationListener<ScrollEndNotification>(
          onNotification: _onScrollEnd,
          child: RefreshIndicator(
              strokeWidth: 2.5,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                      padding: EdgeInsets.all(8),
                      sliver: SliverStaggeredGrid.countBuilder(
                          // 确保即使内容未超出视口范围依然能够触发 refresh 手势
                          crossAxisCount: 3,
                          itemCount: _dramas.length,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          staggeredTileBuilder: (index) =>
                              new StaggeredTile.fit(1),
                          itemBuilder: (content, index) {
                            return DramaItem(
                                index, _dramas.length, _dramas[index]);
                          })),
                  _getFooterWidget()
                ],
              ),
              onRefresh: () {
                logger.info('onRefresh: ${widget.category}');
                return Future.delayed(Duration(seconds: 5),
                    () => logger.info('onRefreshFinished: ${widget.category}'));
              }));
    } else if (_hasError) {
      content = Center(
        child: Text('$_error'),
      );
    } else {
      // 延迟显示 loading widget，
      // 防止切换 tab 时初始化状态立即显示 loading
      content = FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 1000)),
          builder: (content, snapshot) {
            Widget loadingWidget;
            if (snapshot.connectionState == ConnectionState.done) {
              loadingWidget = Center(
                  child: SizedBox(
                width: 38,
                height: 38,
                child: CircularProgressIndicator(),
              ));
            } else {
              loadingWidget = SizedBox.shrink();
            }
            return Container(child: loadingWidget);
          });
    }
    return content;
  }

  Widget _getFooterWidget() {
    Widget footer;
    if (_isPaging) {
      footer = SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
          ));
    } else if (_hasError) {
      if (_error is ApiError &&
          (_error as ApiError).code == ApiErrorCode.NO_MORE_DATA) {
        footer = Text('No more data');
      } else {
        footer = Text('$_error');
      }
    } else if (_page >= _maxPage) {
      footer = Text('The end');
    }
    return SliverToBoxAdapter(
        child: Container(
      constraints: BoxConstraints(minHeight: 128),
      child: Center(child: footer),
    ));
  }

}

class DramaItem extends StatelessWidget {
  final int index;
  final int count;
  final Drama drama;

  DramaItem(this.index, this.count, this.drama);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double posterWidth = mediaQueryData.size.width / 2.0;
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle nameStyle = textTheme.subtitle2.copyWith(
      height: 1.2,
      fontSize: 15,
    );
    TextStyle captionStyle = textTheme.caption.copyWith(fontSize: 12);

    return SizedBox(
        width: posterWidth,
        child: Card(
            margin: EdgeInsets.all(0),
            clipBehavior: Clip.antiAlias,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, drama_details,
                    //     arguments: {
                    //       'playUrl':drama.playUrl,
                    //       'dramaId':drama.dramaId
                    //     });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AspectRatio(
                          aspectRatio: 0.69, // 来自谷歌查询的电影海报标准宽高比
                          child: LayoutBuilder(builder: (BuildContext context,
                              BoxConstraints constraints) {
                            print('Drama poster size: $constraints');
                            return img_provider.Image(
                              drama.posterUrl,
                              width: constraints.maxWidth,
                              height: constraints.maxHeight
                            );
                          })
                          // child:
                          //   LayoutBuilder(builder: (BuildContext context,
                          //     BoxConstraints constraints) {
                          //    return
                          //      Image.network(drama.posterUrl,
                          //        fit: BoxFit.cover, cacheWidth: constraints.maxWidth.toInt(), cacheHeight: constraints.maxHeight.toInt());
                          // })
                      ), // Container(color: Colors.red,))
                      Container(
                        padding: EdgeInsets.only(
                            left: 8, top: 6, right: 8, bottom: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text(drama.name, style: nameStyle),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Text(formatDateTime(drama.resUpdatedAt),
                                  style: captionStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Text(drama.resUpdateStatus,
                                style: captionStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      )
                    ],
                  ),
                ))));
  }

}
