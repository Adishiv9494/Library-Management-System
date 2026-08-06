<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>All Issued Books Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <style>
        :root {
            --bs-body-bg: #f8f9fa;
            --bs-body-color: #212529;
            --card-bg: #ffffff;
            --primary-color: #4e73df;
            --secondary-color: #858796;
            --success-color: #1cc88a;
            --danger-color: #e74a3b;
            --warning-color: #f6c23e;
            --info-color: #36b9cc;
        }
        [data-bs-theme="dark"] {
            --bs-body-bg: #1a1a2e;
            --bs-body-color: #f8f9fa;
            --card-bg: #16213e;
            --primary-color: #5a67d8;
            --secondary-color: #a0aec0;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --info-color: #3b82f6;
        }
        body {
            background-color: var(--bs-body-bg);
            color: var(--bs-body-color);
            transition: all 0.3s ease;
        }
        .card {
            background-color: var(--card-bg);
            border: none;
            border-radius: 0.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        .btn-primary:hover {
            background-color: #3a56c7;
            border-color: #3a56c7;
        }
        .form-control, .form-select {
            background-color: var(--card-bg);
            color: var(--bs-body-color);
            border: 1px solid rgba(0, 0, 0, 0.1);
        }
        .search-card {
            border-left: 0.25rem solid var(--primary-color) !important;
        }
        .back-btn:hover {
            transform: translateX(-3px);
            transition: all 0.3s;
        }
        .theme-toggle:hover {
            transform: rotate(15deg);
            transition: all 0.3s;
        }
        .table {
            background-color: var(--card-bg);
            color: var(--bs-body-color);
        }
        .table th {
            border-bottom-width: 1px;
            border-top: none;
            background-color: rgba(78, 115, 223, 0.1);
            color: var(--primary-color);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
        }
        .table td {
            vertical-align: middle;
            border-top: 1px solid rgba(0, 0, 0, 0.05);
        }
        .record-info { font-size: 0.875rem; color: var(--secondary-color); }
        .status-badge {
            padding: 0.35em 0.65em;
            border-radius: 0.25rem;
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            display: inline-block;
            min-width: 80px;
            text-align: center;
        }
        .status-issued { background-color: var(--success-color); color: white; }
        .status-overdue { background-color: var(--warning-color); color: #000; }
        .status-defaulter { background-color: var(--danger-color); color: white; }
        .status-returned { background-color: var(--info-color); color: white; }
        .filter-label { font-weight: 500; font-size: 0.9rem; margin-bottom: 0.25rem; }
        @media print { .no-print { display: none !important; } }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <button class="btn btn-outline-primary back-btn no-print" onclick="window.history.back()">
                        <i class="fas fa-arrow-left me-2"></i>Back
                    </button>
                    <h2 class="text-center mb-0 fw-bold" style="color: var(--primary-color);">
                        <i class="fas fa-book-open me-2"></i>All Issued Books Report
                    </h2>
                    <div class="d-flex gap-2 no-print">
                        <button class="btn btn-outline-success" id="printPdfBtn"><i class="fas fa-file-pdf me-2"></i>Print</button>
                        <button id="themeToggle" class="btn btn-outline-secondary theme-toggle"><i class="fas fa-moon"></i></button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-4 no-print">
            <div class="col-12">
                <div class="card shadow-sm search-card">
                    <div class="card-body py-3">
                        <div class="row g-3 align-items-end">
                            <div class="col-md-2">
                                <label for="crnFilter" class="filter-label">CRN</label>
                                <input type="text" class="form-control" id="crnFilter" placeholder="Search CRN">
                            </div>
                            <div class="col-md-2">
                                <label for="studentNameFilter" class="filter-label">Student Name</label>
                                <input type="text" class="form-control" id="studentNameFilter" placeholder="Search Name">
                            </div>
                            <div class="col-md-2">
                                <label for="courseFilter" class="filter-label">Course</label>
                                <select class="form-select" id="courseFilter">
                                    <option value="">All Courses</option>
                                    <option value="BCA">BCA</option>
                                    <option value="BBA">BBA</option>
                                    <option value="BTech">B. Tech</option>
                                    <option value="MCA">MCA</option>
                                    <option value="MBA">MBA</option>
                                    <option value="PTech">PolyTech</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label for="fromDate" class="filter-label">From Date</label>
                                <input type="date" class="form-control" id="fromDate">
                            </div>
                            <div class="col-md-2">
                                <label for="toDate" class="filter-label">To Date</label>
                                <input type="date" class="form-control" id="toDate">
                            </div>
                            <div class="col-md-2">
                                <label for="statusFilter" class="filter-label">Status</label>
                                <select class="form-select" id="statusFilter">
                                    <option value="">All</option>
                                    <option value="ISSUED">Issued</option>
                                    <option value="RETURNED">Returned</option>
                                    <option value="OVERDUE">Overdue</option>
                                    <option value="DEFAULTER">Defaulter</option>
                                </select>
                            </div>
                            <div class="row g-2 mt-2">
                                <div class="col-md-12 d-flex align-items-end justify-content-end">
                                    <button class="btn btn-primary me-2" id="applyFilter"><i class="fas fa-filter me-1"></i>Apply</button>
                                    <button class="btn btn-secondary" id="resetFilter"><i class="fas fa-undo me-1"></i>Reset</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover w-100" id="allIssuesTable">
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
                                        <th>Return Date</th>
                                        <th>Status</th>
                                        <th>Fine (₹)</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
    <script>
        $(document).ready(function() {
            const themeToggle = document.getElementById('themeToggle');
            if (localStorage.getItem('theme') === 'dark') {
                document.documentElement.setAttribute('data-bs-theme', 'dark');
                themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
            }
            themeToggle.addEventListener('click', function() {
                if (document.documentElement.getAttribute('data-bs-theme') === 'dark') {
                    document.documentElement.setAttribute('data-bs-theme', 'light');
                    themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
                    localStorage.setItem('theme', 'light');
                } else {
                    document.documentElement.setAttribute('data-bs-theme', 'dark');
                    themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
                    localStorage.setItem('theme', 'dark');
                }
                table.ajax.reload(null, false);
            });

            const table = $('#allIssuesTable').DataTable({
                ajax: {
                    url: 'ViewAllIssuedBook',
                    type: 'POST',
                    data: function(d) {
                        d.crn = $('#crnFilter').val();
                        d.studentName = $('#studentNameFilter').val();
                        d.course = $('#courseFilter').val();
                        d.fromDate = $('#fromDate').val();
                        d.toDate = $('#toDate').val();
                        d.status = $('#statusFilter').val();
                    },
                    dataSrc: function(json) {
                        if (json.success) return json.data;
                        else { console.error(json.message); return []; }
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
                        render: function(d) { return d ? new Date(d).toLocaleDateString('en-IN') : 'N/A'; }
                    },
                    { 
                        data: 'dueDate',
                        render: function(d) { return d ? new Date(d).toLocaleDateString('en-IN') : 'N/A'; }
                    },
                    { 
                        data: 'returnDate',
                        render: function(d) { return d ? new Date(d).toLocaleDateString('en-IN') : 'N/A'; }
                    },
                    { 
                        data: 'status',
                        render: function(d) {
                            let cls = 'status-issued';
                            const statusText = d ? d.toUpperCase() : 'ISSUED';
                            if (statusText === 'RETURNED') cls = 'status-returned';
                            else if (statusText === 'OVERDUE') cls = 'status-overdue';
                            else if (statusText === 'DEFAULTER') cls = 'status-defaulter';
                            return '<span class="status-badge ' + cls + '">' + statusText + '</span>';
                        }
                    },
                    { 
                        data: 'fine_amount',
                        render: function(data) {
                            return '₹' + parseFloat(data || 0).toFixed(2);
                        }
                    }
                ],
                responsive: true,
                scrollX: true,
                scrollY: '60vh',
                language: {
                    emptyTable: "No records found",
                    search: "_INPUT_",
                    searchPlaceholder: "Search records..."
                }
            });

            $('#applyFilter').click(function() { table.ajax.reload(); });
            $('#resetFilter').click(function() {
                $('#crnFilter, #studentNameFilter, #fromDate, #toDate').val('');
                $('#courseFilter, #statusFilter').val('');
                table.ajax.reload();
            });

            $('#printPdfBtn').click(function() {
                const { jsPDF } = window.jspdf;
                const doc = new jsPDF('p', 'pt', 'a4');
                const logoUrl = 'logo2.jpg';
                const img = new Image();
                img.src = logoUrl;

                img.onload = function() {
                    const maxWidth = 100;
                    const ratio = maxWidth / img.width;
                    const logoWidth = maxWidth;
                    const logoHeight = img.height * ratio;
                    doc.addImage(img, 'JPEG', 40, 20, logoWidth, logoHeight);
                    doc.setFontSize(18);
                    doc.setTextColor(40);
                    doc.setFont("helvetica", "bold");
                    doc.text("All Issued Books Report", 40 + logoWidth + 20, 20 + (logoHeight / 2));
                    const now = new Date();
                    doc.setFontSize(10);
                    doc.setFont("helvetica", "normal");
                    doc.text("Generated on: " + now.toLocaleString(), 40 + logoWidth + 20, 20 + (logoHeight / 2) + 20);
                    doc.setDrawColor(200,200,200);
                    doc.line(40, 20 + logoHeight + 20, doc.internal.pageSize.width - 40, 20 + logoHeight + 20);

                    const headers = ["Issue ID", "CRN", "Student", "Contact", "Course", "Accession", "Title", "Author", "Edition", "Issue Date", "Due Date", "Return Date", "Status", "Fine"];
                    const data = [];
                    $('#allIssuesTable tbody tr').each(function() {
                        const rowData = [];
                        $(this).find('td').each(function() {
                            let text = $(this).text().trim();
                            if ($(this).find('.status-badge').length) {
                                text = $(this).find('.status-badge').text().trim();
                            }
                            rowData.push(text);
                        });
                        if (rowData.length > 0 && rowData[0] !== 'No records found') {
                            data.push(rowData);
                        }
                    });

                    doc.autoTable({
                        startY: 20 + logoHeight + 40,
                        head: [headers],
                        body: data,
                        styles: { fontSize: 8, cellPadding: 3 },
                        headStyles: { fillColor: [78,115,223], textColor: 255, fontStyle: 'bold', halign: 'center' },
                        margin: { top: 20 + logoHeight + 40, left: 40, right: 40 }
                    });
                    doc.save("All_Issued_Books_Report_" + new Date().toISOString().slice(0,10) + ".pdf");
                };
                img.onerror = function() {
                    doc.save("All_Issued_Books_Report_" + new Date().toISOString().slice(0,10) + ".pdf");
                };
            });
        });
    </script>
</body>
</html>