  import 'package:BusyBee/JSON/task.dart';
  import 'package:BusyBee/pages/add_task.dart';
  import 'package:BusyBee/pages/profile.dart';
  import 'package:flutter/material.dart';
  import 'package:BusyBee/services/databse_helper.dart';
  import 'package:intl/intl.dart';
  import 'package:provider/provider.dart';
  import 'package:BusyBee/provider/theme_provider.dart';

  enum FilterType { all, completed, pending }

  class Home_page extends StatefulWidget {
    const Home_page({super.key});

    @override
    State<Home_page> createState() => _Home_pageState();
  }

  class _Home_pageState extends State<Home_page> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    FilterType _currentFilter = FilterType.all;

    List<Map<String, dynamic>> allTasks = [];
    List<Map<String, dynamic>> displayedTasks = [];


    final db = DatabseHelper();

    List<Map<String, String?>> tasks = [];
    bool _isDailySelected = true;
    String? _selectedDate;

    @override
    void initState() {
      super.initState();
      _loadTasks();
    }
    void deletedb(){
      db.deleteOldDatabase();
    }

    Future<void> _loadTasks() async {
    final user = db.currentUser;
    if (user != null) {
      final list = await db.gettask(user);

      final mappedTasks = list.map((task) => {
        'title': task.title,
        'description': task.description,
        'date': task.dueDate,
        'completed': task.isCompleted == 1 ? 'true' : 'false',
        'index': task.taskId.toString(),
      }).toList();

      setState(() {
        allTasks = mappedTasks;
        // Apply both daily/monthly and completion filters
        displayedTasks = _applyAllFilters(mappedTasks);
      });
    }
  }

    List<Map<String, dynamic>> _applyAllFilters(List<Map<String, dynamic>> tasks) {
    List<Map<String, dynamic>> filtered = List.from(tasks);
    
    // Daily/monthly filter
    if (_isDailySelected) {
      String today = DateFormat('d-M-y').format(DateTime.now());
      filtered = filtered.where((task) => task['date'] == today).toList();
    }
    
    // Completion status filter
    if (_currentFilter == FilterType.completed) {
      filtered = filtered.where((task) => task['completed'] == 'true').toList();
    } else if (_currentFilter == FilterType.pending) {
      filtered = filtered.where((task) => task['completed'] != 'true').toList();
    }
    
    return filtered;
  }

    Future<void> _addTaskToDb(Task task) async {
      await db.addTask(task);
      await 
      _loadTasks(); // Refresh after adding
    }
    Future<void> deletetask(Map<String, dynamic> task) async {
      final user = db.currentUser;
      if (user != null) {
        await db.deleteTask(task['index']!);
        _loadTasks();
      }
    }
    Future<void> _openAddTaskModal() async {
      final newTask = await showDialog<Map<String, String>>(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SizedBox(height: 500, child: AddTaskScreen(_isDailySelected)),
        ),
      );
      if (newTask != null) {
        // Convert map to Task and save to DB
        final user = db.currentUser;
        if (user != null) {
          Task task = Task(
            title: newTask['title'] ?? '',
            description: newTask['description'] ?? '',
            dueDate: newTask['date'] ?? '',
            //notificationTime: newTask['notificationTime'] ?? '',
            isCompleted: 0,
            userId: user.userid!,
          );
          _addTaskToDb(task);
        }
      }
    }

    String get currentDateString {
      final now = DateTime.now();
      return DateFormat('d MMMM y').format(now);
    }

    List<Map<String, dynamic>> get filteredTasks {
    List<Map<String, dynamic>> filtered = List.from(allTasks);

    // Apply daily/monthly filter
    if (_isDailySelected) {
      String today = DateFormat('d-M-y').format(DateTime.now());
      filtered = filtered.where((task) => task['date'] == today).toList();
    }

    // Apply completion status filter
    if (_currentFilter == FilterType.completed) {
      filtered = filtered.where((task) => task['completed'] == 'true').toList();
    } else if (_currentFilter == FilterType.pending) {
      filtered = filtered.where((task) => task['completed'] != 'true').toList();
    }

    return filtered;
  }
  
    void toggleSwitch(bool isDaily) {
    setState(() {
      _isDailySelected = isDaily;
      displayedTasks = _applyAllFilters(allTasks);
    });
  }

    void _showTaskDetails(Map<String, dynamic> task) async {
      //print("Task details: $task");
      bool isCompleted = task['completed'] == 'true';

      await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setStateDialog) {
              return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogBackgroundColor, // Use theme color
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.orange, size: 15),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            task['title'] ?? '',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, 
                          size: 18, 
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${task['date'] ?? ''} • ${task['notificationTime'] ?? ''}",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      task['description'] ?? '', 
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                          )
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: isCompleted,
                          onChanged: (val) async {
                            setStateDialog(() {
                              isCompleted = val!;
                              task['completed'] = isCompleted ? 'true' : 'false';
                            });
                            final updatedTask = Task(
                              taskId: int.parse(task['index']!),
                              title: task['title'] ?? '',
                              description: task['description'] ?? '',
                              dueDate: task['date'] ?? '',
                              isCompleted: isCompleted ? 1 : 0,
                              userId: db.currentUser?.userid ?? 0,
                            );
                            try {
                              await db.updateTask(updatedTask);
                              _loadTasks();
                            } catch (e) {
                              setStateDialog(() {
                                isCompleted = !isCompleted;
                                task['completed'] = isCompleted ? 'true' : 'false';
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to update task status: ${e.toString()}'))
                              );
                            }
                          },
                          shape: const CircleBorder(),
                        ),
                        Text(
                          isCompleted ? "Completed" : "Mark as completed",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red.shade300,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text("Delete"),
                        onPressed: () {
                          deletetask(task);
                          Navigator.of(context).pop();
                          setState(() {
                            tasks.remove(task);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
            },
          );
        },
      );
      setState(() {});
    }

    void _showFilterPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Filter Tasks'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('All Tasks'),
                leading: _currentFilter == FilterType.all 
                    ? Icon(Icons.check) 
                    : null,
                onTap: () {
                  _applyFilter(FilterType.all);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Completed Tasks'),
                leading: _currentFilter == FilterType.completed 
                    ? Icon(Icons.check) 
                    : null,
                onTap: () {
                  _applyFilter(FilterType.completed);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Pending Tasks'),
                leading: _currentFilter == FilterType.pending 
                    ? Icon(Icons.check) 
                    : null,
                onTap: () {
                  _applyFilter(FilterType.pending);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilter(FilterType filter) {
    setState(() {
      _currentFilter = filter;
      if (filter == FilterType.all) {
        displayedTasks = List.from(allTasks); // Show all tasks
      } else if (filter == FilterType.completed) {
        displayedTasks = allTasks.where((task) => task['completed'] == 'true').toList();
      } else if (filter == FilterType.pending) {
        displayedTasks = allTasks.where((task) => task['completed'] != 'true').toList();
      }
    });
  }


    @override
    Widget build(BuildContext context) {
      const gradient = LinearGradient(
        colors: [
        const Color.fromARGB(255, 230, 81, 0),
        const Color.fromARGB(255, 239, 108, 0),
        const Color.fromARGB(255, 255, 167, 38)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

      return Scaffold(
    key: _scaffoldKey,
    drawer: Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 230, 81, 0),
                        Color.fromARGB(255, 239, 108, 0),
                        Color.fromARGB(255, 255, 167, 38),
                      ],
                    ),
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              ListTile(
              leading: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                title: Text(
                  themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                  style: Theme.of(context).textTheme.bodyLarge, 
                ),
                onTap: () {
                  themeProvider.toggleTheme(); // Use themeProvider directly
                  Navigator.pop(context); // Close the drawer after action
                },
              ),
              ListTile(
                leading: Icon(Icons.filter_list),
                title: Text(
                  'Filter Tasks',
                  style: Theme.of(context).textTheme.bodyLarge, 
                ),
                onTap: () {
                    Navigator.pop(context); // Close drawer first
                    _showFilterPopup(context);
                    },
              ),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text(
                  'Help',
                  style: Theme.of(context).textTheme.bodyLarge, 
                ),
              ),
            ],
          ),
        );
      },
    ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Opacity(
            opacity: .8,
            child: AppBar(
              // flexibleSpace: Container(
              //   decoration: const BoxDecoration(gradient: gradient),
              // ),
              centerTitle: true,
              title: Text(
                'BusyBee',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              automaticallyImplyLeading: false,
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 50),
            Center(
              child: Container(
                width: 250,
                height: 60,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      alignment: _isDailySelected ? Alignment.centerRight : Alignment.centerLeft,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Container(
                        height: 60,
                        width: 120,
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => toggleSwitch(false),
                            child: Center(
                              child: Text(
                                'Monthly',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !_isDailySelected ? Colors.white : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => toggleSwitch(true),
                            child: Center(
                              child: Text(
                                'Daily',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isDailySelected ? Colors.white : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: _isDailySelected
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (!_isDailySelected)
                  const Padding(padding: EdgeInsets.all(30)),

                Expanded(
                  child: Text(
                    currentDateString,
                    textAlign: TextAlign.center, // optional for better centering
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(width: 10),

                if (!_isDailySelected)
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.calendar_today, size: 24),
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) => 
                            Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: const Color.fromARGB(255, 230, 81, 0),
                                //accentColor: const Color.fromARGB(255, 230, 81, 0),
                                colorScheme: ColorScheme.light(primary: const Color.fromARGB(255, 230, 81, 0)),
                                buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!,
                            ),
                        );
                        if (pickedDate != null) {
                          // Do something with the picked date
                          print("Selected date: $pickedDate");
                          // You can setState here to update the UI with the selected date
                          setState(() {
                            _selectedDate = DateFormat('d-M-yyyy').format(pickedDate);
                            print("Formatted date: $_selectedDate");
                            displayedTasks = allTasks.where((task) {
                              return task['date'] == _selectedDate;
                            }).toList();
                          });
                        }
                      },
                    ),
                  ),
              ],
            ),
            // IconButton(onPressed: (){
            //   deletedb();
            // }, icon: Icon(Icons.delete), color: Colors.red),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: displayedTasks.length,
                itemBuilder: (context, index) {
                  final task = displayedTasks[index] as Map<String, dynamic>;
                  final isCompleted = task['completed'].toString() == 'true';
                  return GestureDetector(
                    onTap: () => _showTaskDetails(task),
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        leading: task['completed'] == 'true'
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                        title: Text(
                          task['title'] ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: task['completed'] == 'true'
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        //subtitle: Text(task['notificationTime'] ?? ''),
                      ),
                    ),
                  );
                },
              ),
            ),
            
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openAddTaskModal,
          child: const Icon(Icons.add),
          backgroundColor: const Color.fromARGB(255, 255, 116, 3),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Opacity(
          opacity: .8,
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 6.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: const Icon(Icons.menu), onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                }),
                const SizedBox(width: 40), // Space for FAB
                IconButton(icon: const Icon(Icons.person_outline), onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>EditProfileScreen()));
                }),
              ],
            ),
          ),
        ),
      );
    }
  }