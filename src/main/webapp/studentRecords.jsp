<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Student Records</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <style>
        :root { --bs-body-bg: #f8f9fa; --bs-body-color: #212529; --card-bg: #ffffff; --primary-color: #4e73df; --secondary-color: #858796; }
        [data-bs-theme="dark"] { --bs-body-bg: #1a1a2e; --bs-body-color: #f8f9fa; --card-bg: #16213e; --primary-color: #5a67d8; --secondary-color: #a0aec0; }
        body { background-color: var(--bs-body-bg); color: var(--bs-body-color); transition: all 0.3s ease; }
        .card { background-color: var(--card-bg); border: none; border-radius: 0.5rem; box-shadow: 0 0.15rem 1.75rem 0 rgba(58,59,69,0.15); }
        .btn-primary { background-color: var(--primary-color); border-color: var(--primary-color); }
        .form-control, .form-select { background-color: var(--card-bg); color: var(--bs-body-color); border: 1px solid rgba(0,0,0,0.1); }
        .search-card { border-left: 0.25rem solid var(--primary-color) !important; }
        .back-btn:hover { transform: translateX(-3px); transition: all 0.3s; }
        .theme-toggle:hover { transform: rotate(15deg); transition: all 0.3s; }
        .table { background-color: var(--card-bg); color: var(--bs-body-color); }
        .table th { border-bottom-width: 1px; border-top: none; background-color: rgba(78,115,223,0.1); color: var(--primary-color); font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; }
        .table td { vertical-align: middle; border-top: 1px solid rgba(0,0,0,0.05); }
        .student-name { font-weight: 500; }
        .record-info { font-size: 0.875rem; color: var(--secondary-color); }
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
                        <i class="fas fa-user-graduate me-2"></i>Student Records
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
                            <div class="col-md-3">
                                <label for="searchCRN" class="form-label fw-semibold">CRN</label>
                                <input type="text" class="form-control" id="searchCRN" placeholder="Search CRN">
                            </div>
                            <div class="col-md-3">
                                <label for="searchName" class="form-label fw-semibold">Student Name</label>
                                <input type="text" class="form-control" id="searchName" placeholder="Search Name">
                            </div>
                            <div class="col-md-3">
                                <label for="courseFilter" class="form-label fw-semibold">Course</label>
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
                                <label for="limitSelect" class="form-label fw-semibold">Records per page</label>
                                <select class="form-select" id="limitSelect">
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                    <option value="50">50</option>
                                    <option value="100">100</option>
                                </select>
                            </div>
                            <div class="col-md-1 d-flex align-items-end">
                                <button class="btn btn-primary w-100" id="searchBtn"><i class="fas fa-search"></i></button>
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
                            <table class="table table-hover" id="studentsTable">
                                <thead><tr><th width="5%">S.No.</th><th width="15%">CRN</th><th width="40%">Name</th><th width="20%">Contact</th><th width="20%">Course</th></tr></thead>
                                <tbody id="studentsTableBody"><tr><td colspan="5" class="text-center py-4"><i class="fas fa-spinner fa-spin me-2"></i>Loading...</td></tr></tbody>
                            </table>
                        </div>
                        <div class="d-flex justify-content-between align-items-center p-3 border-top">
                            <div id="recordInfo" class="record-info"></div>
                            <nav><ul class="pagination mb-0" id="pagination"></ul></nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
            });

            let currentPage = 1, currentLimit = 10, totalRecords = 0;

            function loadStudentData() {
                const searchCRN = $('#searchCRN').val().trim();
                const searchName = $('#searchName').val().trim();
                const course = $('#courseFilter').val();
                $.ajax({
                    url: 'StudentsRecordsData',
                    type: 'GET',
                    data: { page: currentPage, limit: currentLimit, searchCRN: searchCRN, searchName: searchName, course: course },
                    dataType: 'json',
                    beforeSend: function() {
                        $('#studentsTableBody').html('<tr><td colspan="5" class="text-center py-4"><i class="fas fa-spinner fa-spin me-2"></i>Loading...</td></tr>');
                    },
                    success: function(data) {
                        if (data.error) { Swal.fire({ icon: 'error', title: 'Error', text: data.error }); return; }
                        totalRecords = data.totalRecords;
                        renderStudentData(data.data);
                        renderPagination();
                        updateRecordInfo();
                    },
                    error: function() { Swal.fire({ icon: 'error', title: 'Error', text: 'Failed to load data' }); }
                });
            }

            function renderStudentData(students) {
                const tableBody = $('#studentsTableBody');
                tableBody.empty();
                if (students.length === 0) {
                    tableBody.append('<tr><td colspan="5" class="text-center py-4 text-muted">No records found</td></tr>');
                    return;
                }
                const startSerial = (currentPage - 1) * currentLimit + 1;
                $.each(students, function(index, student) {
                    const row = '<tr><td>' + (startSerial + index) + '</td><td>' + student.crn + '</td><td><i class="fas fa-user me-2"></i>' + student.name + '</td><td><i class="fas fa-phone me-2"></i>' + student.contact + '</td><td><i class="fas fa-graduation-cap me-2"></i>' + (student.course || '') + '</td></tr>';
                    tableBody.append(row);
                });
            }

            function renderPagination() {
                const totalPages = Math.ceil(totalRecords / currentLimit);
                const pagination = $('#pagination');
                pagination.empty();
                if (totalPages <= 1) return;
                // Previous
                pagination.append('<li class="page-item' + (currentPage === 1 ? ' disabled' : '') + '"><a class="page-link" href="#" data-page="' + (currentPage - 1) + '"><i class="fas fa-chevron-left"></i></a></li>');
                let startPage = Math.max(1, currentPage - 2), endPage = Math.min(totalPages, currentPage + 2);
                if (startPage > 1) pagination.append('<li class="page-item"><a class="page-link" href="#" data-page="1">1</a></li>');
                if (startPage > 2) pagination.append('<li class="page-item disabled"><a class="page-link">...</a></li>');
                for (let i = startPage; i <= endPage; i++) {
                    pagination.append('<li class="page-item' + (i === currentPage ? ' active' : '') + '"><a class="page-link" href="#" data-page="' + i + '">' + i + '</a></li>');
                }
                if (endPage < totalPages - 1) pagination.append('<li class="page-item disabled"><a class="page-link">...</a></li>');
                if (endPage < totalPages) pagination.append('<li class="page-item"><a class="page-link" href="#" data-page="' + totalPages + '">' + totalPages + '</a></li>');
                pagination.append('<li class="page-item' + (currentPage === totalPages ? ' disabled' : '') + '"><a class="page-link" href="#" data-page="' + (currentPage + 1) + '"><i class="fas fa-chevron-right"></i></a></li>');
                
                pagination.find('.page-link').click(function(e) {
                    e.preventDefault();
                    const page = parseInt($(this).data('page'));
                    if (page && page !== currentPage && page >= 1 && page <= totalPages) {
                        currentPage = page;
                        loadStudentData();
                    }
                });
            }

            function updateRecordInfo() {
                const startRecord = (currentPage - 1) * currentLimit + 1;
                const endRecord = Math.min(currentPage * currentLimit, totalRecords);
                $('#recordInfo').html('<i class="fas fa-info-circle me-1"></i>Showing ' + startRecord + ' to ' + endRecord + ' of ' + totalRecords + ' records');
            }

            $('#searchBtn').click(function() { currentPage = 1; loadStudentData(); });
            $('#searchCRN, #searchName').keypress(function(e) { if (e.which === 13) { currentPage = 1; loadStudentData(); } });
            $('#courseFilter, #limitSelect').change(function() { currentPage = 1; loadStudentData(); });
            loadStudentData();

            // PDF generation (with logo)
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
                    doc.addImage(img, 'PNG', 40, 20, logoWidth, logoHeight);
                    doc.setFontSize(18);
                    doc.setTextColor(40);
                    doc.setFont("helvetica", "bold");
                    doc.text("Student Records", 40 + logoWidth + 20, 20 + (logoHeight / 2));
                    const now = new Date();
                    doc.setFontSize(10);
                    doc.setFont("helvetica", "normal");
                    doc.text("Generated on: " + now.toLocaleString(), 40 + logoWidth + 20, 20 + (logoHeight / 2) + 20);
                    doc.setDrawColor(200,200,200);
                    doc.line(40, 20 + logoHeight + 20, doc.internal.pageSize.width - 40, 20 + logoHeight + 20);
                    const headers = ["S.No.", "CRN", "Student", "Contact", "Course"];
                    const data = [];
                    $('#studentsTableBody tr').each(function(index) {
                        const rowData = [];
                        $(this).find('td').each(function() {
                            rowData.push($(this).clone().find('i').remove().end().text().trim());
                        });
                        if (rowData.length > 0) data.push(rowData);
                    });
                    doc.autoTable({
                        startY: 20 + logoHeight + 40,
                        head: [headers],
                        body: data,
                        styles: { fontSize: 10, cellPadding: 4 },
                        headStyles: { fillColor: [78,115,223], textColor: 255, fontStyle: 'bold', halign: 'center' },
                        columnStyles: { 0: { halign: 'center' }, 1: { halign: 'center' }, 4: { halign: 'center' } },
                        margin: { top: 20 + logoHeight + 40, left: 40, right: 40 },
                        didDrawPage: function(data) {
                            doc.setFontSize(10);
                            doc.setTextColor(150);
                            doc.text('Page ' + data.pageNumber + ' of ' + doc.internal.getNumberOfPages(), data.settings.margin.left, doc.internal.pageSize.height - 20);
                        }
                    });
                    doc.save("Student_Records_" + new Date().toISOString().slice(0,10) + ".pdf");
                    Swal.fire({ icon: 'success', title: 'PDF Generated', text: 'Student records exported', timer: 2000, showConfirmButton: false });
                };
                img.onerror = function() {
                    Swal.fire({ icon: 'error', title: 'Error', text: 'Logo not found. PDF generated without logo.' });
                    generatePDFWithoutLogo(doc);
                };
            });
        });
    </script>
</body>
</html>