<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>View Issued Books with Status</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #858796;
            --success-color: #1cc88a;
            --danger-color: #e74a3b;
            --warning-color: #f6c23e;
            --card-bg-light: #ffffff;
            --card-bg-dark: #16213e;
            --text-light: #212529;
            --text-dark: #f8f9fa;
            --body-bg-light: #f8f9fa;
            --body-bg-dark: #1a1a2e;
            --table-bg-light: #ffffff;
            --table-bg-dark: #16213e;
            --table-border-light: #dee2e6;
            --table-border-dark: #495057;
        }

        [data-bs-theme="dark"] {
            --primary-color: #4e73df;
            --success-color: #1cc88a;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --info-color: #36b9cc;
            --body-bg: #1a1a2e;
            --card-bg: #16213e;
            --text-color: #f8f9fa;
            --border-color: #2c3e50;
        }

        [data-bs-theme="light"] {
            --bs-body-bg: var(--body-bg-light);
            --bs-body-color: var(--text-light);
            --card-bg: var(--card-bg-light);
            --border-color: #dee2e6;
            --table-bg: var(--table-bg-light);
            --table-border: var(--table-border-light);
        }

        body {
            background-color: var(--bs-body-bg);
            color: var(--bs-body-color);
            transition: all 0.3s ease;
        }

        .card {
            background-color: var(--card-bg);
            border: none;
            border-radius: 0.75rem;
            box-shadow: 0 0.25rem 0.75rem rgba(0, 0, 0, 0.1);
            margin-bottom: 1rem;
        }

        .card-body {
            padding: 1.5rem;
        }

        .theme-toggle-btn {
            transition: transform 0.3s;
        }
        .theme-toggle-btn:hover {
            transform: rotate(15deg);
        }

        .table-container {
            border-radius: 0.75rem;
            overflow: hidden;
            margin-top: 1rem;
        }

        .dataTables_wrapper .dataTables_filter input {
            background-color: var(--card-bg);
            color: var(--bs-body-color);
            border: 1px solid var(--border-color);
            margin-left: 0.5rem;
        }

        .dataTables_wrapper .dataTables_length select {
            background-color: var(--card-bg);
            color: var(--bs-body-color);
            border: 1px solid var(--border-color);
        }

        table.dataTable {
            background-color: var(--table-bg);
            border-color: var(--table-border) !important;
            width: 100% !important;
            margin: 0 !important;
        }

        table.dataTable thead th {
            border-bottom-color: var(--table-border) !important;
            white-space: nowrap;
            padding: 12px 15px;
            background-color: rgba(78, 115, 223, 0.1);
        }

        table.dataTable tbody td {
            border-top-color: var(--table-border) !important;
            padding: 10px 15px;
            vertical-align: middle;
        }

        .status-badge {
            padding: 0.5em 0.75em;
            font-size: 0.8em;
            font-weight: 700;
            border-radius: 0.375rem;
            white-space: nowrap;
            display: inline-block;
            text-align: center;
            min-width: 90px;
        }

        .status-issued {
            background-color: rgba(28, 200, 138, 0.2);
            color: var(--success-color);
            border: 1px solid var(--success-color);
        }

        .status-overdue {
            background-color: rgba(246, 194, 62, 0.2);
            color: var(--warning-color);
            border: 1px solid var(--warning-color);
        }

        .status-defaulter {
            background-color: rgba(231, 74, 59, 0.2);
            color: var(--danger-color);
            border: 1px solid var(--danger-color);
        }

        @media (max-width: 768px) {
            .card-body { padding: 1rem; }
            .container-fluid { padding: 0 10px; }
            #bookIssuesTable th, #bookIssuesTable td { padding: 8px 10px; font-size: 0.9em; }
        }
    </style>
</head>
<body>
    <div class="container-fluid py-3">
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <button class="btn btn-outline-primary" onclick="window.history.back()">
                                <i class="fas fa-arrow-left me-2"></i>Back
                            </button>
                            <h2 class="text-center mb-0 fw-bold" style="color: var(--primary-color);">
                                <i class="fas fa-book-open me-2"></i>Book Issuance Records
                            </h2>
                            <button id="themeToggle" class="btn btn-outline-secondary theme-toggle-btn">
                                <i class="fas fa-moon"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <div class="table-responsive table-container">
                            <table id="bookIssuesTable" class="table table-hover w-100">
                                <thead>
                                    <tr>
                                        <th>Issue ID</th>
                                        <th>CRN</th>
                                        <th>Student Name</th>
                                        <th>Contact</th>
                                        <th>Course</th>
                                        <th>Accession No</th>
                                        <th>Book Title</th>
                                        <th>Author</th>
                                        <th>Edition</th>
                                        <th>Issue Date</th>
                                        <th>Due Date</th>
                                        <th>Status</th>
                                        <th>Fine (₹)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Data loaded dynamically via AJAX -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

    <script>
    $(document).ready(function() {
        function initTheme() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            $('html').attr('data-bs-theme', savedTheme);
            $('#themeToggle i').removeClass('fa-moon fa-sun').addClass(savedTheme === 'dark' ? 'fa-sun' : 'fa-moon');
        }

        $('#themeToggle').click(function() {
            const currentTheme = $('html').attr('data-bs-theme');
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            $('html').attr('data-bs-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            $('#themeToggle i').removeClass('fa-moon fa-sun').addClass(newTheme === 'dark' ? 'fa-sun' : 'fa-moon');
            bookIssuesTable.ajax.reload(null, false);
        });

        initTheme();

        const bookIssuesTable = $('#bookIssuesTable').DataTable({
            ajax: {
                url: 'ViewIssuedBooks',
                type: 'POST',
                dataSrc: function(json) {
                    if (json.success) {
                        return json.data;
                    } else {
                        console.error("Error:", json.message);
                        return [];
                    }
                },
                error: function(xhr, error, thrown) {
                    console.error("AJAX Error:", xhr.responseText);
                }
            },
            columns: [
                { data: 'issueId' },
                { data: 'crn' },
                { data: 'studentName' },
                { data: 'contact' },
                { data: 'course' },
                { data: 'accessionNumber' },
                { data: 'bookTitle' },
                { data: 'author' },
                { data: 'edition' },
                { 
                    data: 'issueDate',
                    render: function(data) {
                        return data ? new Date(data).toLocaleDateString('en-IN') : 'N/A';
                    }
                },
                { 
                    data: 'dueDate',
                    render: function(data) {
                        return data ? new Date(data).toLocaleDateString('en-IN') : 'N/A';
                    }
                },
                { 
                    data: 'status',
                    render: function(data) {
                        let badgeClass = 'status-issued';
                        let statusText = data ? data.toUpperCase() : 'ISSUED';
                        if (statusText === 'OVERDUE') {
                            badgeClass = 'status-overdue';
                        } else if (statusText === 'DEFAULTER') {
                            badgeClass = 'status-defaulter';
                        }
                        return '<span class="status-badge ' + badgeClass + '">' + statusText + '</span>';
                    }
                },
                { 
                    data: 'fineAmount',
                    render: function(data) {
                        return '₹' + parseFloat(data || 0).toFixed(2);
                    }
                }
            ],
            responsive: true,
            scrollX: true,
            scrollY: '60vh',
            language: {
                emptyTable: "No book issue records found",
                zeroRecords: "No matching records found",
                search: "_INPUT_",
                searchPlaceholder: "Search records..."
            }
        });

        setInterval(function() {
            bookIssuesTable.ajax.reload(null, false);
        }, 30000);
    });
    </script>
</body>
</html>