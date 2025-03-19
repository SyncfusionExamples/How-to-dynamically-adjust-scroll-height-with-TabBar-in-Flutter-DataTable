import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(const MaterialApp(home: ScrollViewExampleApp(),debugShowCheckedModeBanner: false,));
}

class ScrollViewExampleApp extends StatefulWidget {
  const ScrollViewExampleApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ScrollViewExampleApp>
    with SingleTickerProviderStateMixin {
  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource;
  late ScrollController _controller;
  late DataGridController _dataGridController;
  double currentSizedBoxHeight = 200;
  double initialSizedBoxHeight = 200;
  double rowHeight = 50;
  double headerRowHeight = 50;
  late TabController _tabController;
  late double dataGridHeight;
  double tabHeight = 50;

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
    double newHeight = (initialSizedBoxHeight - shrinkOffset).clamp(
      0,
      initialSizedBoxHeight,
    );

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
      _dataGridController.scrollToVerticalOffset(
        _controller.offset - initialSizedBoxHeight,
      );
    }

    // Ensure DataGrid scrolls back to the top when user scrolls back up.
    if (_controller.offset <= 0) {
      _dataGridController.scrollToRow(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _controller,
            child: SizedBox(
              height: initialSizedBoxHeight + tabHeight + dataGridHeight,
              child: Transform.translate(
                // Moves content based on scroll position for a smooth effect.
                offset: Offset(
                  0,
                  _controller.hasClients ? _controller.offset : 0,
                ),
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
                          ),
                        ),
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
                        height:
                            constraints.maxHeight -
                            currentSizedBoxHeight -
                            tabHeight,
                        child: TabBarView(
                          controller: _tabController,
                          children: List.generate(3, (index) {
                            return buildDataGrid();
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildDataGrid() {
    return GestureDetector(
      // Allows dragging to adjust the scrolling.
      onPanUpdate: (details) {
        _controller.jumpTo(_controller.offset - details.delta.dy);
      },
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(scrollbars: false),
        child: SfDataGrid(
          showVerticalScrollbar: false,
          verticalScrollPhysics: const NeverScrollableScrollPhysics(),
          headerRowHeight: headerRowHeight,
          rowHeight: rowHeight,
          controller: _dataGridController,
          source: employeeDataSource,
          columns: <GridColumn>[
            GridColumn(
              columnName: 'id',
              label: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: const Text('ID'),
              ),
            ),
            GridColumn(
              columnName: 'name',
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text('Name'),
              ),
            ),
            GridColumn(
              columnName: 'designation',
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  'Designation',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              columnName: 'salary',
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text('Salary'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Employee> getEmployeeData() {
    return [
      Employee(10001, 'James', 'Project Lead', 20000),
      Employee(10002, 'Kate', 'Manager', 30000),
      Employee(10003, 'Lara', 'Developer', 15000),
      Employee(10004, 'Mike', 'Designer', 15000),
      Employee(10005, 'Marty', 'Developer', 15000),
      Employee(10006, 'Nina', 'QA Engineer', 14000),
      Employee(10007, 'Blake', 'Developer', 15000),
      Employee(10008, 'Paul', 'Support', 13000),
      Employee(10009, 'Gabe', 'Developer', 15000),
      Employee(10010, 'Grim', 'Developer', 15000),
      Employee(10011, 'Sam', 'HR', 16000),
      Employee(10012, 'Liz', 'Manager', 30000),
      Employee(10013, 'Tom', 'Project Lead', 20000),
      Employee(10014, 'Eva', 'Designer', 15000),
      Employee(10015, 'Omar', 'Developer', 15000),
      Employee(10016, 'Ivy', 'QA Engineer', 14000),
      Employee(10017, 'Nash', 'Developer', 15000),
      Employee(10018, 'Roy', 'Support', 13000),
      Employee(10019, 'Zane', 'Developer', 15000),
      Employee(10020, 'Kara', 'Manager', 30000),
      Employee(10021, 'Leo', 'Developer', 15000),
      Employee(10022, 'Elle', 'HR', 16000),
      Employee(10023, 'Joel', 'Support', 13000),
      Employee(10024, 'Tina', 'QA Engineer', 14000),
      Employee(10025, 'Kyle', 'Designer', 15000),
      Employee(10026, 'Zoe', 'Developer', 15000),
      Employee(10027, 'Max', 'Project Lead', 20000),
      Employee(10028, 'Iris', 'Developer', 15000),
      Employee(10029, 'Dean', 'Developer', 15000),
      Employee(10030, 'Faye', 'Manager', 30000),
    ];
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.salary);

  /// Id of an employee.
  final int id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;

  /// Salary of an employee.
  final int salary;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<Employee> employeeData}) {
    _employeeData =
        employeeData
            .map<DataGridRow>(
              (e) => DataGridRow(
                cells: [
                  DataGridCell<int>(columnName: 'id', value: e.id),
                  DataGridCell<String>(columnName: 'name', value: e.name),
                  DataGridCell<String>(
                    columnName: 'designation',
                    value: e.designation,
                  ),
                  DataGridCell<int>(columnName: 'salary', value: e.salary),
                ],
              ),
            )
            .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((e) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Text(e.value.toString()),
            );
          }).toList(),
    );
  }
}
