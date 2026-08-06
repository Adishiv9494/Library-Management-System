<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Book Records</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    
    <style>
        :root {
            --bs-body-bg: #f8f9fa;
            --bs-body-color: #212529;
            --card-bg: #ffffff;
            --table-bg: #ffffff;
            --primary-color: #4e73df;
            --secondary-color: #858796;
        }
        
        [data-bs-theme="dark"] {
            --bs-body-bg: #1a1a2e;
            --bs-body-color: #f8f9fa;
            --card-bg: #16213e;
            --table-bg: #16213e;
            --primary-color: #5a67d8;
            --secondary-color: #a0aec0;
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
        
        .table {
            background-color: var(--table-bg);
            color: var(--bs-body-color);
            margin-bottom: 0;
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
            border-radius: 0.35rem;
        }
        
        .form-control:focus, .form-select:focus {
            background-color: var(--card-bg);
            color: var(--bs-body-color);
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
        }
        
        .pagination .page-item .page-link {
            background-color: var(--card-bg);
            border-color: rgba(0, 0, 0, 0.1);
            color: var(--bs-body-color);
        }
        
        .pagination .page-item.active .page-link {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .record-info {
            font-size: 0.875rem;
            color: var(--secondary-color);
        }
        
        .search-card {
            border-left: 0.25rem solid var(--primary-color) !important;
        }
        
        .back-btn {
            transition: all 0.3s;
        }
        
        .back-btn:hover {
            transform: translateX(-3px);
        }
        
        .theme-toggle {
            transition: all 0.3s;
        }
        
        .theme-toggle:hover {
            transform: rotate(15deg);
        }
        
        .spinner-container {
            height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .empty-table {
            height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--secondary-color);
        }
        
        .book-name {
            font-weight: 500;
        }
        
        .author-name {
            font-style: italic;
        }
        
        .price-badge {
            background-color: rgba(25, 135, 84, 0.1);
            color: #198754;
            padding: 0.25em 0.6em;
            border-radius: 0.25rem;
            font-weight: 500;
        }
        
        [data-bs-theme="dark"] .price-badge {
            background-color: rgba(25, 135, 84, 0.3);
        }
        
        .serial-number {
            color: var(--secondary-color);
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <button class="btn btn-outline-primary back-btn" onclick="window.history.back()">
                        <i class="fas fa-arrow-left me-2"></i>Back
                    </button>
                    <h2 class="text-center mb-0 fw-bold" style="color: var(--primary-color);">
                        <i class="fas fa-book me-2"></i>Book Records
                    </h2>
                    <div class="d-flex gap-2">
                        <button class="btn btn-outline-success" id="printPdfBtn">
                            <i class="fas fa-file-pdf me-2"></i>Print
                        </button>
                        <button id="themeToggle" class="btn btn-outline-secondary theme-toggle">
                            <i class="fas fa-moon"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow-sm search-card">
                    <div class="card-body py-3">
                        <div class="row g-3 align-items-end">
                            <div class="col-md-6">
                                <label for="searchInput" class="form-label fw-semibold">Search Books</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                                    <input type="text" class="form-control" id="searchInput" placeholder="Search by accession number, title, author or publisher...">
                                </div>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button class="btn btn-primary w-100" id="searchBtn">
                                    <i class="fas fa-search me-2"></i>Search
                                </button>
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
                            <table class="table table-hover" id="booksTable">
                                <thead>
                                    <tr>
                                        <th width="5%">S.No.</th>
                                        <th width="10%">Accession No.</th>
                                        <th width="25%">Title</th>
                                        <th width="20%">Author</th>
                                        <th width="20%">Publisher</th>
                                        <th width="10%">Edition</th>
                                        <th width="10%">Price</th>
                                    </tr>
                                </thead>
                                <tbody id="booksTableBody">
                                    <!-- Data will be loaded here -->
                                </tbody>
                            </table>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center p-3 border-top">
                            <div id="recordInfo" class="record-info"></div>
                            <nav aria-label="Page navigation">
                                <ul class="pagination mb-0" id="pagination">
                                    <!-- Pagination will be loaded here -->
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- jsPDF -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>

    <script>
        $(document).ready(function() {
            let currentPage = 1;
            let currentLimit = 10;
            let currentSearch = '';
            let totalRecords = 0;
            
            // Initialize theme
            const themeToggle = document.getElementById('themeToggle');
            const prefersDarkScheme = window.matchMedia('(prefers-color-scheme: dark)');
            
            if (localStorage.getItem('theme') === 'dark' || (!localStorage.getItem('theme') && prefersDarkScheme.matches)) {
                document.documentElement.setAttribute('data-bs-theme', 'dark');
                themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
            } else {
                document.documentElement.setAttribute('data-bs-theme', 'light');
                themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
            }
            
            // Theme toggle
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
            
            // Load initial data
            loadBookData();
            
            // Search button click event
            $('#searchBtn').click(function() {
                currentPage = 1;
                loadBookData();
            });
            
            // Enter key in search input
            $('#searchInput').keypress(function(e) {
                if (e.which === 13) {
                    currentPage = 1;
                    loadBookData();
                }
            });
            
            // Limit select change event
            $('#limitSelect').change(function() {
                currentLimit = parseInt($(this).val());
                currentPage = 1;
                loadBookData();
            });
            
            // Function to load book data
            function loadBookData() {
                currentSearch = $('#searchInput').val().trim();
                
                $.ajax({
                    url: 'BookRecordsServlet',
                    type: 'GET',
                    data: {
                        page: currentPage,
                        limit: currentLimit,
                        search: currentSearch
                    },
                    dataType: 'json',
                    beforeSend: function() {
                        $('#booksTableBody').html('<tr><td colspan="7" class="text-center"><div class="spinner-container"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div></td></tr>');
                    },
                    success: function(data) {
                        if (data.error) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: data.error
                            });
                            return;
                        }
                        
                        totalRecords = data.totalRecords;
                        renderBookData(data.data);
                        renderPagination();
                        updateRecordInfo();
                    },
                    error: function(xhr, status, error) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'Failed to load book data: ' + error
                        });
                    }
                });
            }
            
            // Function to render book data
            function renderBookData(books) {
                const tableBody = $('#booksTableBody');
                tableBody.empty();
                
                if (books.length === 0) {
                    tableBody.append('<tr><td colspan="7"><div class="empty-table"><i class="fas fa-info-circle me-2"></i>No records found</div></td></tr>');
                    return;
                }
                
                const startSerial = (currentPage - 1) * currentLimit + 1;
                
                $.each(books, function(index, book) {
                    const row = $('<tr>');
                    
                    // Serial Number
                    row.append($('<td>').addClass('serial-number').text(startSerial + index));
                    
                    // Accession Number
                    row.append($('<td>').text(book.accession_number));
                    
                    // Book Title with icon
                    const titleCell = $('<td>').addClass('book-name');
                    titleCell.append($('<i>').addClass('fas fa-book me-2'));
                    titleCell.append(document.createTextNode(book.book_name));
                    row.append(titleCell);
                    
                    // Author with icon
                    const authorCell = $('<td>').addClass('author-name');
                    authorCell.append($('<i>').addClass('fas fa-user-pen me-2'));
                    authorCell.append(document.createTextNode(book.author));
                    row.append(authorCell);
                    
                    // Publisher with icon
                    const publisherCell = $('<td>');
                    publisherCell.append($('<i>').addClass('fas fa-building me-2'));
                    publisherCell.append(document.createTextNode(book.publisher));
                    row.append(publisherCell);
                    
                    // Edition
                    row.append($('<td>').text(book.edition));
                    
                    // Price with badge
                    const priceCell = $('<td>');
                    const priceBadge = $('<span>').addClass('price-badge');
                    priceBadge.append($('<i>').addClass('fas fa-rupee-sign me-1'));
                    priceBadge.append(document.createTextNode(book.price.toFixed(2)));
                    priceCell.append(priceBadge);
                    row.append(priceCell);
                    
                    tableBody.append(row);
                });
            }
            
            // Function to render pagination
            function renderPagination() {
                const totalPages = Math.ceil(totalRecords / currentLimit);
                const pagination = $('#pagination');
                pagination.empty();
                
                if (totalPages <= 1) return;
                
                // Previous button
                const prevLi = $('<li>').addClass('page-item').toggleClass('disabled', currentPage === 1);
                const prevLink = $('<a>').addClass('page-link').attr('href', '#').html('<i class="fas fa-chevron-left"></i>');
                prevLink.click(function(e) {
                    e.preventDefault();
                    if (currentPage > 1) {
                        currentPage--;
                        loadBookData();
                    }
                });
                prevLi.append(prevLink);
                pagination.append(prevLi);
                
                // Page numbers
                const maxVisiblePages = 5;
                let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
                let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
                
                if (endPage - startPage + 1 < maxVisiblePages) {
                    startPage = Math.max(1, endPage - maxVisiblePages + 1);
                }
                
                if (startPage > 1) {
                    const firstLi = $('<li>').addClass('page-item');
                    const firstLink = $('<a>').addClass('page-link').attr('href', '#').text(1);
                    firstLink.click(function(e) {
                        e.preventDefault();
                        currentPage = 1;
                        loadBookData();
                    });
                    firstLi.append(firstLink);
                    pagination.append(firstLi);
                    
                    if (startPage > 2) {
                        pagination.append($('<li>').addClass('page-item disabled').append($('<a>').addClass('page-link').text('...')));
                    }
                }
                
                for (let i = startPage; i <= endPage; i++) {
                    const pageLi = $('<li>').addClass('page-item').toggleClass('active', i === currentPage);
                    const pageLink = $('<a>').addClass('page-link').attr('href', '#').text(i);
                    pageLink.click(function(e) {
                        e.preventDefault();
                        currentPage = i;
                        loadBookData();
                    });
                    pageLi.append(pageLink);
                    pagination.append(pageLi);
                }
                
                if (endPage < totalPages) {
                    if (endPage < totalPages - 1) {
                        pagination.append($('<li>').addClass('page-item disabled').append($('<a>').addClass('page-link').text('...')));
                    }
                    
                    const lastLi = $('<li>').addClass('page-item');
                    const lastLink = $('<a>').addClass('page-link').attr('href', '#').text(totalPages);
                    lastLink.click(function(e) {
                        e.preventDefault();
                        currentPage = totalPages;
                        loadBookData();
                    });
                    lastLi.append(lastLink);
                    pagination.append(lastLi);
                }
                
                // Next button
                const nextLi = $('<li>').addClass('page-item').toggleClass('disabled', currentPage === totalPages);
                const nextLink = $('<a>').addClass('page-link').attr('href', '#').html('<i class="fas fa-chevron-right"></i>');
                nextLink.click(function(e) {
                    e.preventDefault();
                    if (currentPage < totalPages) {
                        currentPage++;
                        loadBookData();
                    }
                });
                nextLi.append(nextLink);
                pagination.append(nextLi);
            }
            
            // Function to update record info
            function updateRecordInfo() {
                const startRecord = (currentPage - 1) * currentLimit + 1;
                const endRecord = Math.min(currentPage * currentLimit, totalRecords);
                $('#recordInfo').html(`<i class="fas fa-info-circle me-1"></i>Showing ${startRecord} to ${endRecord} of ${totalRecords} records`);
            }
            
            // Print PDF button click handler
            $('#printPdfBtn').on('click', function() {
                generatePDF();
            });
            
            // Function to generate PDF with properly sized logo
            function generatePDF() {
                try {
                    const { jsPDF } = window.jspdf;
                    const doc = new jsPDF('p', 'pt', 'a4');
                    
                    // First load the logo image
                    const logoUrl = 'logo2.jpg';
                    const img = new Image();
                    img.src = logoUrl;
                    
                    img.onload = function() {
                        // Calculate logo dimensions (max width 100px)
                        const maxWidth = 100;
                        const ratio = maxWidth / img.width;
                        const logoWidth = maxWidth;
                        const logoHeight = img.height * ratio;
                        
                        // Add header with logo and title to each page
                        const addHeader = () => {
                            // Add logo to the PDF (left side)
                            doc.addImage(img, 'PNG', 40, 20, logoWidth, logoHeight);
                            
                            // Add title and date to the right of the logo
                            doc.setFontSize(18);
                            doc.setTextColor(40);
                            doc.setFont("helvetica", "bold");
                            doc.text("Book Records", 40 + logoWidth + 20, 20 + (logoHeight / 2));
                            
                            // Add generation date below the title
                            const now = new Date();
                            doc.setFontSize(10);
                            doc.setFont("helvetica", "normal");
                            doc.text("Generated on: " + now.toLocaleString(), 40 + logoWidth + 20, 20 + (logoHeight / 2) + 20);
                            
                            // Add a line separator
                            doc.setDrawColor(200, 200, 200);
                            doc.setLineWidth(1);
                            doc.line(40, 20 + logoHeight + 20, doc.internal.pageSize.width - 40, 20 + logoHeight + 20);
                        };
                        
                        // Get all data from the table
                        const headers = [
                            "S.No.", 
                            "Accession No.", 
                            "Title", 
                            "Author", 
                            "Publisher", 
                            "Edition", 
                            "Price"
                        ];
                        
                        const data = [];
                        $('#booksTableBody tr').each(function(index) {
                            const rowData = [];
                            $(this).find('td').each(function() {
                                // Handle price badge separately
                                if ($(this).find('.price-badge').length > 0) {
                                    rowData.push($(this).find('.price-badge').text().trim());
                                } else {
                                    // Remove any icons and get clean text
                                    rowData.push($(this).clone().find('i').remove().end().text().trim());
                                }
                            });
                            if (rowData.length > 0) {
                                data.push(rowData);
                            }
                        });
                        
                        // Create the table with header callback for each page
                        doc.autoTable({
                            startY: 20 + logoHeight + 40, // Start below the header
                            head: [headers],
                            body: data,
                            styles: {
                                fontSize: 10,
                                cellPadding: 4,
                                overflow: 'linebreak',
                                valign: 'middle'
                            },
                            headStyles: {
                                fillColor: [78, 115, 223],
                                textColor: 255,
                                fontStyle: 'bold',
                                halign: 'center'
                            },
                            columnStyles: {
                                0: { cellWidth: 'auto', halign: 'center' },  // S.No.
                                1: { cellWidth: 'auto', halign: 'center' },  // Accession No.
                                2: { cellWidth: 'auto' },  // Title
                                3: { cellWidth: 'auto' },  // Author
                                4: { cellWidth: 'auto' },  // Publisher
                                5: { cellWidth: 'auto', halign: 'center' },  // Edition
                                6: { cellWidth: 'auto', halign: 'right' }    // Price
                            },
                            margin: { 
                                top: 20 + logoHeight + 40,
                                left: 40,
                                right: 40
                            },
                            didDrawPage: function(data) {
                                // Add header to each page
                                addHeader();
                                
                                // Add page numbers
                                const pageCount = doc.internal.getNumberOfPages();
                                doc.setFontSize(10);
                                doc.setTextColor(150);
                                doc.text(
                                    'Page ' + data.pageNumber + ' of ' + pageCount,
                                    data.settings.margin.left,
                                    doc.internal.pageSize.height - 20
                                );
                            }
                        });
                        
                        // Save the PDF
                        doc.save("Book_Records_" + new Date().toISOString().slice(0, 10) + ".pdf");
                        
                        // Show success message
                        Swal.fire({
                            icon: 'success',
                            title: 'PDF Generated',
                            text: 'All book records have been exported to PDF',
                            timer: 2000,
                            showConfirmButton: false
                        });
                    };
                    
                    img.onerror = function() {
                        // Fallback if logo fails to load
                        generatePDFWithoutLogo(doc);
                    };
                    
                } catch (error) {
                    console.error('PDF generation error:', error);
                    Swal.fire({
                        icon: 'error',
                        title: 'PDF Generation Failed',
                        text: 'An error occurred while generating the PDF: ' + error.message
                    });
                }
            }
            
            // Fallback function if logo fails to load
            function generatePDFWithoutLogo(doc) {
                try {
                    // Set initial y position
                    let yPosition = 40;
                    
                    // Add title
                    doc.setFontSize(18);
                    doc.setTextColor(40);
                    doc.setFont("helvetica", "bold");
                    doc.text("Book Records", 40, yPosition);
                    yPosition += 30;
                    
                    // Add generation date
                    const now = new Date();
                    doc.setFontSize(10);
                    doc.setFont("helvetica", "normal");
                    doc.text("Generated on: " + now.toLocaleString(), 40, yPosition);
                    yPosition += 30;
                    
                    // Add a line separator
                    doc.setDrawColor(200, 200, 200);
                    doc.setLineWidth(1);
                    doc.line(40, yPosition, doc.internal.pageSize.width - 40, yPosition);
                    yPosition += 20;
                    
                    // Get all data from the table
                    const headers = [
                        "S.No.", 
                        "Accession No.", 
                        "Title", 
                        "Author", 
                        "Publisher", 
                        "Edition", 
                        "Price"
                    ];
                    
                    const data = [];
                    $('#booksTableBody tr').each(function(index) {
                        const rowData = [];
                        $(this).find('td').each(function() {
                            // Handle price badge separately
                            if ($(this).find('.price-badge').length > 0) {
                                rowData.push($(this).find('.price-badge').text().trim());
                            } else {
                                // Remove any icons and get clean text
                                rowData.push($(this).clone().find('i').remove().end().text().trim());
                            }
                        });
                        if (rowData.length > 0) {
                            data.push(rowData);
                        }
                    });
                    
                    // Create the table
                    doc.autoTable({
                        startY: yPosition,
                        head: [headers],
                        body: data,
                        styles: {
                            fontSize: 10,
                            cellPadding: 4,
                            overflow: 'linebreak',
                            valign: 'middle'
                        },
                        headStyles: {
                            fillColor: [78, 115, 223],
                            textColor: 255,
                            fontStyle: 'bold',
                            halign: 'center'
                        },
                        columnStyles: {
                            0: { cellWidth: 'auto', halign: 'center' },  // S.No.
                            1: { cellWidth: 'auto', halign: 'center' },  // Accession No.
                            2: { cellWidth: 'auto' },  // Title
                            3: { cellWidth: 'auto' },  // Author
                            4: { cellWidth: 'auto' },  // Publisher
                            5: { cellWidth: 'auto', halign: 'center' },  // Edition
                            6: { cellWidth: 'auto', halign: 'right' }    // Price
                        },
                        margin: { 
                            top: yPosition,
                            left: 40,
                            right: 40
                        },
                        didDrawPage: function(data) {
                            // Add page numbers
                            const pageCount = doc.internal.getNumberOfPages();
                            doc.setFontSize(10);
                            doc.setTextColor(150);
                            doc.text(
                                'Page ' + data.pageNumber + ' of ' + pageCount,
                                data.settings.margin.left,
                                doc.internal.pageSize.height - 20
                            );
                        }
                    });
                    
                    // Save the PDF
                    doc.save("Book_Records_" + new Date().toISOString().slice(0, 10) + ".pdf");
                    
                    Swal.fire({
                        icon: 'success',
                        title: 'PDF Generated',
                        text: 'PDF created without logo',
                        timer: 2000,
                        showConfirmButton: false
                    });
                } catch (error) {
                    console.error('PDF generation error (without logo):', error);
                    Swal.fire({
                        icon: 'error',
                        title: 'PDF Generation Failed',
                        text: 'Error creating PDF without logo: ' + error.message
                    });
                }
            }
        });
    </script>
</body>
</html>