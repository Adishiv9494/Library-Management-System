<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="logo2.jpg">
    <title>Add Book</title>
    
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
            --primary-color: #4e73df;
            --secondary-color: #858796;
            --form-min-height: 450px;
        }
        
        [data-bs-theme="dark"] {
            --bs-body-bg: #1a1a2e;
            --bs-body-color: #f8f9fa;
            --card-bg: #16213e;
            --primary-color: #5a67d8;
            --secondary-color: #a0aec0;
        }
        
        body {
            background-color: var(--bs-body-bg);
            color: var(--bs-body-color);
            transition: all 0.3s ease;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .container {flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 2rem 0;
        }
            
        
        .card {
            background-color: var(--card-bg);
            border: none;
            border-radius: 0.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            min-height: var(--form-min-height);
            padding: 1.5rem;
        }
        
        .card-body {
            padding: 2.5rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            padding: 0.5rem 1.5rem;
            font-size: 1rem;
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
            padding: 0.75rem 1rem;
            font-size: 1rem;
        }
        
        .form-control:focus, .form-select:focus {
            background-color: var(--card-bg);
            color: var(--bs-body-color);
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
        }
        
        .back-btn {
            transition: all 0.3s;
            padding: 0.5rem 1.5rem;
        }
        
        .back-btn:hover {
            transform: translateX(-3px);
        }
        
        .theme-toggle {
            transition: all 0.3s;
            padding: 0.5rem 1rem;
        }
        
        .theme-toggle:hover {
            transform: rotate(15deg);
        }
        
        .form-card {
            border-left: 0.25rem solid var(--primary-color) !important;
        }
        
        .form-label {
            font-weight: 500;
            margin-bottom: 0.75rem;
            font-size: 1rem;
        }
        
        .input-hint {
            font-size: 0.85rem;
            color: var(--secondary-color);
            margin-top: 0.5rem;
        }
        
        .input-group-text {
            background-color: rgba(78, 115, 223, 0.1);
            color: var(--primary-color);
            border: 1px solid rgba(0, 0, 0, 0.1);
        }
        
        h2 {
            font-size: 2rem;
            margin: 0;
        }
        
        .row.g-3 > [class^="col-"] {
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <button class="btn btn-outline-primary back-btn" onclick="window.history.back()">
                        <i class="fas fa-arrow-left me-2"></i>Back
                    </button>
                    <h2 class="text-center mb-0 fw-bold" style="color: var(--primary-color);">
                        <i class="fas fa-book me-2"></i>Add New Book
                    </h2>
                    <button id="themeToggle" class="btn btn-outline-secondary theme-toggle">
                        <i class="fas fa-moon"></i>
                    </button>
                </div>
            </div>
        </div>
        
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm form-card">
                    <div class="card-body">
                        <form id="bookForm" action="AddBookServlet" method="post">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="accessionNumber" class="form-label">Starting Accession Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-barcode"></i></span>
                                        <input type="number" class="form-control" id="accessionNumber" name="accessionNumber" 
                                               placeholder="Enter starting accession number" required min="1">
                                    </div>
                                    <div class="input-hint">Unique identifier for the book (e.g., 1001)</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="numCopies" class="form-label">Number of Copies</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-copy"></i></span>
                                        <input type="number" class="form-control" id="numCopies" name="numCopies" 
                                               placeholder="Enter number of copies" required min="1" value="1">
                                    </div>
                                    <div class="input-hint">How many copies of this book to add</div>
                                </div>
                                
                                <div class="col-md-12">
                                    <label for="bookName" class="form-label">Book Name</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-book"></i></span>
                                        <input type="text" class="form-control" id="bookName" name="bookName" 
                                               placeholder="Enter book name" required minlength="3">
                                    </div>
                                    <div class="input-hint">Full title of the book (e.g., Introduction to Java Programming)</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="author" class="form-label">Author</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-user-pen"></i></span>
                                        <input type="text" class="form-control" id="author" name="author" 
                                               placeholder="Enter author name" required minlength="3">
                                    </div>
                                    <div class="input-hint">Author's full name (e.g., John Doe)</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="publisher" class="form-label">Publisher</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-building"></i></span>
                                        <input type="text" class="form-control" id="publisher" name="publisher" 
                                               placeholder="Enter publisher name" required minlength="3">
                                    </div>
                                    <div class="input-hint">Publisher's name (e.g., Pearson Education)</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="edition" class="form-label">Edition</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-layer-group"></i></span>
                                        <input type="text" class="form-control" id="edition" name="edition" 
                                               placeholder="Enter edition" required>
                                    </div>
                                    <div class="input-hint">Edition information (e.g., 5th Edition, 2023)</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="price" class="form-label">Price (₹)</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-rupee-sign"></i></span>
                                        <input type="number" class="form-control" id="price" name="price" 
                                               placeholder="Enter price" required min="0" step="0.01">
                                    </div>
                                    <div class="input-hint">Price of the book in Indian Rupees</div>
                                </div>
                                
                                <div class="col-12 mt-4">
                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <button type="reset" class="btn btn-outline-secondary me-md-2">
                                            <i class="fas fa-undo me-2"></i>Reset Form
                                        </button>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>Save Book
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
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
    
    <script>
        $(document).ready(function() {
            // Initialize theme
            const themeToggle = document.getElementById('themeToggle');
            const prefersDarkScheme = window.matchMedia('(prefers-color-scheme: dark)');
            
            // Check for saved theme preference or use system preference
            if (localStorage.getItem('theme') === 'dark' || (!localStorage.getItem('theme') && prefersDarkScheme.matches)) {
                document.documentElement.setAttribute('data-bs-theme', 'dark');
                themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
            } else {
                document.documentElement.setAttribute('data-bs-theme', 'light');
                themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
            }
            
            // Theme toggle functionality
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
            
            // Form submission with validation
            $('#bookForm').submit(function(e) {
                e.preventDefault();
                
                // Get form values
                const accessionNumber = $('#accessionNumber').val().trim();
                const numCopies = $('#numCopies').val().trim();
                const bookName = $('#bookName').val().trim();
                const author = $('#author').val().trim();
                const publisher = $('#publisher').val().trim();
                const edition = $('#edition').val().trim();
                const price = $('#price').val().trim();
                
                // Validate Accession Number
                if (!accessionNumber || isNaN(accessionNumber) || parseInt(accessionNumber) <= 0) {
                    showError('Invalid Accession Number', 'Please enter a valid positive accession number');
                    return;
                }
                
                // Validate Number of Copies
                if (!numCopies || isNaN(numCopies) || parseInt(numCopies) <= 0) {
                    showError('Invalid Number of Copies', 'Please enter a valid positive number of copies');
                    return;
                }
                
                // Validate Book Name
                if (bookName.length < 3) {
                    showError('Invalid Book Name', 'Book name must be at least 3 characters long');
                    return;
                }
                
                // Validate Author
                if (author.length < 3) {
                    showError('Invalid Author', 'Author name must be at least 3 characters long');
                    return;
                }
                
                // Validate Publisher
                if (publisher.length < 3) {
                    showError('Invalid Publisher', 'Publisher name must be at least 3 characters long');
                    return;
                }
                
                // Validate Edition
                if (!edition) {
                    showError('Edition Required', 'Please enter the edition information');
                    return;
                }
                
                // Validate Price
                if (!price || isNaN(price) || parseFloat(price) < 0) {
                    showError('Invalid Price', 'Please enter a valid positive price');
                    return;
                }
                
                // Submit form via AJAX
                $.ajax({
                    url: 'AddBookServlet',
                    type: 'POST',
                    data: $(this).serialize(),
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            Swal.fire({
                                icon: 'success',
                                title: 'Success!',
                                text: response.message,
                                confirmButtonColor: 'var(--primary-color)',
                                willClose: () => {
                                    // Redirect to books page after success
                                    window.location.href = 'BooksRecords.jsp';
                                }
                            });
                        } else {
                            showError('Operation Failed', response.message || 'Failed to add book(s)');
                        }
                    },
                    error: function(xhr, status, error) {
                        showError('Server Error', 'Failed to communicate with server: ' + error);
                    }
                });
            });
            
            // Helper function to show error messages
            function showError(title, message) {
                Swal.fire({
                    icon: 'error',
                    title: title,
                    text: message,
                    confirmButtonColor: 'var(--primary-color)'
                });
            }
        });
    </script>
</body>
</html>