# How to dynamically adjust scroll height with TabBar in Flutter DataTable (SfDataGrid)?

In this article, we will show you how to dynamically adjust scroll height with TabBar in [Flutter DataTable](https://www.syncfusion.com/flutter-widgets/flutter-datagrid).

Initialize the [SfDataGrid]() with the necessary properties and set up the DataGridSource, calculating the initial height using [DataGridSource.rows](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSource/rows.html). Add a listener to the [ScrollController](https://api.flutter.dev/flutter/widgets/ScrollController-class.html) to update the height of a SizedBox based on the scroll position. Additionally, reset the scroll position when switching tabs. In the build method, use a [SingleChildScrollView](https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html) containing a SizedBox that dynamically adjusts its height. Inside the SizedBox, include a TabBar and TabBarView to display the DataGrid. Use a GestureDetector to handle drag updates and adjust the scroll position accordingly. The [DataGridController](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridController-class.html) manages vertical scrolling when the SizedBox collapses, ensuring content remains accessible. This setup enables smooth scrolling and dynamic height adjustment for the DataGrid within the TabBar.

```dart
 @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _dataGridController = DataGridController();
    _tabController = TabController(length: 3, vsync: this);
    employees = getEmployeeData();
    employeeDataSource = EmployeeDataSource(employeeData: employees);
    // Calculate the initial height of the DataGrid based on row count.
    dataGridHeight =
        (employeeDataSource.rows.length * rowHeight) + headerRowHeight;
    // Add listener to handle scroll-based height adjustments.
    _controller.addListener(_updateSizedBoxHeight);

    // Listen to tab changes and reset scroll position.
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _resetScrollOffset();
      }
    });
  }

  // Resets the scroll position and restores the initial height when switching tabs.
  void _resetScrollOffset() {
    _controller.jumpTo(0);
    _dataGridController.scrollToRow(0);
    setState(() {
      // Restore the initial height.
      currentSizedBoxHeight = initialSizedBoxHeight;
    });
  }

  // Updates the height of a SizedBox dynamically based on scroll position.
  void _updateSizedBoxHeight() {
    double shrinkOffset = _controller.offset;
    double newHeight =
        (initialSizedBoxHeight - shrinkOffset).clamp(0, initialSizedBoxHeight);

    if (newHeight != currentSizedBoxHeight) {
      setState(() {
        currentSizedBoxHeight = newHeight;
      });
    } else {
      // Ensures UI updates when initial scroll.
      setState(() {});
    }
    // If the height is fully collapsed, adjust DataGrid scroll position.
    if (newHeight == 0) {
      _dataGridController
          .scrollToVerticalOffset(_controller.offset - initialSizedBoxHeight);
    }

    // Ensure DataGrid scrolls back to the top when user scrolls back up.
    if (_controller.offset <= 0) {
      _dataGridController.scrollToRow(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          controller: _controller,
          child: SizedBox(
            height: initialSizedBoxHeight + tabHeight + dataGridHeight,
            child: Transform.translate(
              // Moves content based on scroll position for a smooth effect.
              offset:
                  Offset(0, _controller.hasClients ? _controller.offset : 0),
              child: SizedBox(
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    // Displays a resizable header space before the TabBar.
                    SizedBox(
                      height: currentSizedBoxHeight,
                      child: const Center(
                          child: Text(
                        'Tab Bar',
                        style: TextStyle(fontSize: 40),
                      )),
                    ),
                    SizedBox(
                      height: tabHeight,
                      child: TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: "Tab 1"),
                          Tab(text: "Tab 2"),
                          Tab(text: "Tab 3"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight -
                          currentSizedBoxHeight -
                          tabHeight,
                      child: TabBarView(
                        controller: _tabController,
                        children: List.generate(3, (index) {
                          return buildDataGrid();
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
```

You can download this example on [GitHub](https://github.com/SyncfusionExamples/How-to-dynamically-adjust-scroll-height-with-TabBar-in-Flutter-DataTable).
