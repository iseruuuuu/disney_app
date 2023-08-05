
# TDL APP Architecture

## Bird's-eye view
<img width="100%" src="https://github.com/iseruuuuu/disney_app/assets/67954894/1f80810d-6d5a-46fd-9760-b26a31151474">

### Screen
- The part that the user interacts with directly, displaying elements of the user interface (UI) (buttons, text fields, lists, etc.) The View typically displays data based on instructions from the ViewModel.

### ViewModel
- The ViewModel acts as the connector between the View and Model; it is responsible for preparing and managing the data to be displayed in the UI and also translating user actions from the View (e.g., button clicks) into the appropriate business logic.

### Usecase
- A Use case represents business logic. A single Use case represents a single business action (e.g., user login, data retrieval, etc.) The Use case receives requests from the ViewModel, retrieves and manipulates data using the required Repository, and returns the results to the ViewModel.

### Repository
- Repository is an abstraction layer for data retrieval and storage.Repository retrieves data from different data sources such as APIs or databases and serves it to the UseCase or business logic.Using the Repository pattern, other parts of the application can easily access the data without worrying about where the data comes from.

### API
- The API is one way to retrieve data from Firebase; the API is used directly by the Repository, which then passes the retrieved data to Usecase.

